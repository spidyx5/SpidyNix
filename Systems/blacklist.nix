# /etc/nixos/SpidyNix/Systems/blacklist.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # BLACKLISTED KERNEL MODULES
  # ============================================================================
  # Modules that will not be loaded by the kernel
  # ============================================================================
  boot.blacklistedKernelModules = [
    # ============================================================================
    # OBSCURE NETWORK PROTOCOLS
    # ============================================================================
    # Old, rare, or insecure network protocols
    # ============================================================================
    "af_802154"       # IEEE 802.15.4 (low-rate wireless personal area networks)
    "appletalk"       # AppleTalk (obsolete Apple networking protocol)
    "atm"             # Asynchronous Transfer Mode
    "ax25"            # Amateur X.25 (packet radio)
    "decnet"          # DECnet (DEC networking protocol)
    "econet"          # Econet (Acorn computers network)
    "ipx"             # Internetwork Packet Exchange (Novell NetWare)
    "n-hdlc"          # High-level Data Link Control
    "netrom"          # NetRom (amateur packet radio)
    "p8022"           # IEEE 802.3 (raw Ethernet)
    "p8023"           # Novell raw IEEE 802.3
    "psnap"           # SubNetwork Access Protocol
    "rds"             # Reliable Datagram Sockets
    "rose"            # ROSE packet radio protocol
    "tipc"            # Transparent Inter-Process Communication
    "x25"             # X.25 protocol

    # ============================================================================
    # OLD/RARE FILESYSTEMS
    # ============================================================================
    # Filesystems that are rarely used and potentially vulnerable
    # ============================================================================
    "adfs"            # Acorn Disc Filing System (Acorn computers)
    "affs"            # Amiga Fast File System
    "befs"            # Be File System (BeOS)
    "bfs"             # SCO UnixWare Boot File System
    "cramfs"          # Compressed ROM/RAM filesystem
    "efs"             # Extent File System (SGI IRIX)
    "erofs"           # Enhanced Read-Only File System
    "exofs"           # Extended Object File System
    "f2fs"            # Flash-Friendly File System (usually not needed on desktop)
    "freevxfs"        # Veritas filesystem driver
    "gfs2"            # Global File System 2 (Red Hat cluster filesystem)
    "hfs"             # Hierarchical File System (old Mac)
    "hfsplus"         # HFS Plus (modern Mac, but rarely needed on Linux)
    "hpfs"            # High Performance File System (OS/2)
    "jffs2"           # Journalling Flash File System v2 (embedded systems)
    "jfs"             # Journaled File System (IBM)
    "ksmbd"           # SMB3 Kernel Server
    "minix"           # Minix filesystem
    "nilfs2"          # New Implementation of Log-structured File System
    "omfs"            # Optimized MPEG Filesystem
    "qnx4"            # QNX4 filesystem
    "qnx6"            # QNX6 filesystem
    "squashfs"        # Compressed read-only filesystem (used by Snap, may want to keep if using Snap)
    "sysv"            # System V filesystem
    "udf"             # Universal Disk Format (optical media)

    # ============================================================================
    # SECURITY-SENSITIVE MODULES
    # ============================================================================
    # Modules that pose security risks or enable DMA attacks
    # ============================================================================
    "firewire-core"   # FireWire can enable DMA attacks
    "thunderbolt"     # Thunderbolt can enable DMA attacks (Thunderspy)
    "vivid"           # Virtual Video Test Driver (unnecessary for normal use)

    # ============================================================================
    # ADDITIONAL MODULES (Optional - uncomment if needed)
    # ============================================================================
    # Other modules you might want to blacklist
    # ============================================================================
    "pcspkr"           # PC speaker (annoying beeps)
    "snd_pcsp"         # PC speaker sound driver
    "iTCO_wdt"         # Intel TCO watchdog timer
    "nouveau"          # Open-source NVIDIA driver (if using proprietary)
    "radeon"           # Old AMD/ATI driver (if using amdgpu)
  ];
}
