# /etc/nixos/SpidyNix/Softwares/basic.nix
{ config, pkgs, lib, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ==========================================================================
    # BASIC SYSTEM PACKAGES
    # ==========================================================================
    # Essential CLI tools
    git                   # Version control
    wget                  # File downloader
    curl                  # URL transfer tool
    unzip
    p7zip
    p7zip-rar
    usbutils              # USB utilities (lsusb)
    nvtopPackages.full   # Hardware info
    imv                   # Image viewer
    jaq                   # JSON processor (jq alternative)
    matugen               # Material Design color generation
    gnupg                 # GPG encryption

    # File management CLI
    eza                   # Modern ls replacement
    bat                   # Better cat with syntax highlighting
    ripgrep               # Fast grep alternative
    fd                    # Fast find alternative

    # Clipboard utilities
    wl-clipboard          # Wayland clipboard utilities
    wl-clipboard-rs       # Rust implementation
    cliphist              # Clipboard history manager
    clipboard-jh          # Another clipboard manager

    # Utilities CLI
    zstd                  # Compression utility
    age                   # Modern encryption tool
    dig                   # DNS lookup utility
    # bat                   # Better cat with syntax highlighting (listed above)
    electron
    # & CLI tools
    tldr                  # Simplified man pages

    # Specialized CLI tools
    xdg-utils
    ueberzugpp
    dosfstools
    evtest
    # fuzzel               # Application launcher (move to home config)

    # ==========================================================================
    # SYSTEM GUI APPLICATIONS
    # ==========================================================================
    networkmanagerapplet  # Network manager applet
    hyprpolkitagent                      # Modern Polkit Agent (Replaces polkit-gnome)
    # ==========================================================================
    # SYSTEM PACKAGES
    # ==========================================================================
    # Audio system packages
    pipewire              # PipeWire CLI tools
    wireplumber           # PipeWire session manager
    jack2                 # JACK audio connection kit
    cava                  # Console audio visualizer
    libsixel              # Sixel graphics library
    alsa-utils            # ALSA utilities (alsamixer, amixer, etc.)

    # Bluetooth system
    bluez                 # Bluetooth protocol stack
    bluez-tools           # Bluetooth tools

    # System monitoring & management
    lm_sensors            # Hardware temperature monitoring
    ananicy-rules-cachyos_git  # CPU scheduling rules for improved system performance

    # ==========================================================================
    # DISPLAY & BRIGHTNESS
    # ==========================================================================
    brightnessctl         # Brightness control
    gammastep             # Screen temperature adjustment
    wlsunset              # Day/night gamma adjustments

    # ==========================================================================
    # NOTIFICATIONS
    # ==========================================================================
    libnotify             # Desktop notifications

    # System utilities
    cryptsetup            # Disk encryption utilities
    ffmpeg
    nix-output-monitor    # Better build output
    nvd                   # Nix version diff tool
    nh
    libsecret
    glib
    appimage-run          # Needed For AppImage Support
    libisoburn
    catnest

    # File system tools
    btrfs-progs           # Btrfs utilities
    f2fs-tools            # F2fs utilities
    btrfs-assistant
    busybox               # Core utilities replacement
    mimalloc
    bees
    compsize
    # dosfstools            # DOS filesystem utilities (listed above)
    # ==========================================================================
    # SCREENSHOT & RECORDING GUI
    # ==========================================================================
    grim                  # Screenshot utility
    slurp                 # Region selector for screenshots
    wl-screenrec           # Screen recorder
    swappy                # Screenshot editor


    # Network & security system tools
    nmap                  # Network scanner
    wireshark             # Network protocol analyzer

    apparmor-utils        # AppArmor profile tools
    apparmor-profiles     # Additional AppArmor profiles
    tpm2-tools            # TPM2 utilities
    lynis                 # Security auditing tool

    # Hardware acceleration & GPU
    seatd
    mods
    pciutils
    google-fonts
    fontforge-gtk
    # ==========================================================================
    # TERMINAL EMULATORS & SHELL UI
    # ==========================================================================
    kitty                 # GPU-accelerated terminal emulator

    # ==========================================================================
    # AUDIO & MULTIMEDIA GUI
    # ==========================================================================
    pavucontrol           # PulseAudio/PipeWire volume control
    pwvucontrol           # Native PipeWire volume control
    easyeffects           # Audio effects for PipeWire
    qpwgraph              # Qt-based PipeWire graph manager
    # SYSTEM MONITORING & UTILITIES
    # ==========================================================================
    btop                  # Modern resource monitor
    fastfetch             # System information display
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # ============================================================================
  # SYSTEM SHELLS
  # ============================================================================
  # Available shells for users
  environment.shells = with pkgs; [
    nushell
    zsh
    fish
    bash
  ];

  # ============================================================================
  # NIX-LD - DYNAMIC LINKER FOR NIXOS
  # ============================================================================
  # Allows running dynamically linked binaries on NixOS
  # ============================================================================
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Standard libraries
      stdenv.cc.cc.lib
      zlib-ng               # zlib replacement with multithreading
      openssl
      libGL
      SDL2
      libusb1
      gtk4
      libkrb5
      keyutils
      glibc
      libressl
      dbus-broker
      fuse3
      vulkan-loader
      vulkan-headers
      vulkan-tools
      zluda
    ];
  };
}

# ============================================================================
# BASIC PACKAGES CONFIGURATION
# ============================================================================
# This file defines basic system and productivity packages installed via environment.systemPackages
# Includes essential tools and nix-ld libraries for dynamic linking
# ============================================================================
# NOTES:
# - This configuration provides essential system utilities and CLI tools
# - Includes development tools, file managers, audio system packages, and system monitoring
# - nix-ld enables running dynamically linked binaries on NixOS
# - For troubleshooting:
#   - Check package installation: which PACKAGE_NAME
#   - Verify nix-ld: nix-ld --help
# - To customize:
#   - Add/remove packages as needed
#   - Modify nix-ld libraries if required for specific applications
# ============================================================================
