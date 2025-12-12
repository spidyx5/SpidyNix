#!/usr/bin/env bash

# ==============================================================================
# CONFIGURATION
# ==============================================================================
DISK_NOXIAN="/dev/mapper/mock-noxian"
DISK_MOTIVATION="/dev/mapper/mock-motivation"
DISK_BOOT="/dev/nvme0n1p1"
DISK_SWAP="/dev/mapper/mock-fang"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper for logging
log() { echo -e "${GREEN}[*] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }
err() { echo -e "${RED}[ERROR] $1${NC}"; exit 1; }

# ==============================================================================
# FUNCTIONS
# ==============================================================================

do_format() {
    warn "WARNING: YOU SELECTED OPTION 1 (FORMAT)"
    warn "This will DESTROY data on:"
    warn "  - $DISK_NOXIAN"
    warn "  - $DISK_BOOT"
    warn "Data on $DISK_MOTIVATION will be PRESERVED (only mounted)."
    
    echo -n "Are you sure? (Type 'yes' to continue): "
    read -r response
    if [ "$response" != "yes" ]; then
        err "Aborted by user."
    fi

    log "Formatting Boot Partition ($DISK_BOOT) to FAT32..."
    mkfs.vfat -F 32 -n BOOT "$DISK_BOOT" || err "Failed to format boot"

    log "Formatting Noxian ($DISK_NOXIAN) to Btrfs..."
    mkfs.btrfs -f -L "dark_valley" "$DISK_NOXIAN" || err "Failed to format noxian"

    log "Creating Subvolumes on Noxian..."
    # Mount temporarily to create subvolumes
    mount -t btrfs "$DISK_NOXIAN" /mnt
    
    btrfs subvolume create /mnt/root || err "Failed to create root subvol"
    btrfs subvolume create /mnt/home || err "Failed to create home subvol"
    btrfs subvolume create /mnt/nix  || err "Failed to create nix subvol"
    btrfs subvolume create /mnt/persist || err "Failed to create persist subvol"
    
    umount /mnt
    log "Formatting and Subvolume creation complete."
}

do_mount() {
    log "Starting Mount Process..."

    # 1. Mount Root (Noxian)
    # Options: subvol=root, compress=zstd:4, noatime
    log "Mounting / (Root)..."
    mount -t btrfs -o subvol=root,compress=zstd:4,noatime "$DISK_NOXIAN" /mnt || err "Failed mounting root"

    # 2. Create Directory Structure
    log "Creating directories..."
    mkdir -p /mnt/{home,nix,persist,boot,flat}
    mkdir -p /mnt/media/motivation/{Computer,Games,Media,Temp,Learning,Edit}

    # 3. Mount Noxian Subvolumes
    log "Mounting Noxian subvolumes..."
    
    # /home -> subvol=home, compress=zstd:5
    mount -t btrfs -o subvol=home,compress=zstd:5,noatime "$DISK_NOXIAN" /mnt/home

    # /nix -> subvol=nix, compress=zstd:4
    mount -t btrfs -o subvol=nix,compress=zstd:4,noatime "$DISK_NOXIAN" /mnt/nix

    # /persist -> subvol=persist, compress-force=zstd:7 (Note: compress-force)
    mount -t btrfs -o subvol=persist,compress-force=zstd:7,noatime "$DISK_NOXIAN" /mnt/persist

    # /flat -> subvolid=5 (Emergency access)
    mount -t btrfs -o subvolid=5,noatime "$DISK_NOXIAN" /mnt/flat

    # 4. Mount Boot
    log "Mounting Boot..."
    mount "$DISK_BOOT" /mnt/boot || err "Failed mounting boot"

    # 5. Mount Motivation (Data Drive) Subvolumes
    # We check if drive exists first to be safe
    if [ -e "$DISK_MOTIVATION" ]; then
        log "Mounting Motivation subvolumes..."

        # Computer -> compress-force=zstd:7
        mount -t btrfs -o subvol=Computer,compress-force=zstd:7,noatime "$DISK_MOTIVATION" /mnt/media/motivation/Computer

        # Games -> nodatacow, compress-force=zstd:5
        mount -t btrfs -o subvol=Games,nodatacow,noatime,compress-force=zstd:5 "$DISK_MOTIVATION" /mnt/media/motivation/Games

        # Media -> compress-force=zstd:6
        mount -t btrfs -o subvol=Media,compress-force=zstd:6,noatime "$DISK_MOTIVATION" /mnt/media/motivation/Media

        # Temp -> compress=zstd:1
        mount -t btrfs -o subvol=Temp,compress=zstd:1,noatime "$DISK_MOTIVATION" /mnt/media/motivation/Temp

        # Learning -> compress-force=zstd:9
        mount -t btrfs -o subvol=Learning,compress-force=zstd:9,noatime "$DISK_MOTIVATION" /mnt/media/motivation/Learning

        # Edit -> compress-force=zstd:7
        mount -t btrfs -o subvol=Edit,compress-force=zstd:7,noatime "$DISK_MOTIVATION" /mnt/media/motivation/Edit
    else
        warn "Motivation drive ($DISK_MOTIVATION) not found! Skipping."
    fi

    # 6. Swap
    if [ -e "$DISK_SWAP" ]; then
        log "Activating Swap..."
        swapon "$DISK_SWAP" || warn "Failed to activate swap"
    else
        warn "Swap device ($DISK_SWAP) not found."
    fi

    log "Mounting Complete. Structure:"
    findmnt /mnt
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then 
  err "Please run as root"
fi

OPTION=$1

case $OPTION in
    1)
        do_format
        do_mount
        ;;
    2)
        do_mount
        ;;
    *)
        echo "Usage: ./live_partition.sh [option]"
        echo "  1  - Format Noxian/Boot, create subvolumes, and mount everything."
        echo "  2  - Mount everything (no formatting)."
        exit 1
        ;;
esac