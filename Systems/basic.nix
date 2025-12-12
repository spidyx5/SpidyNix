{ config, pkgs, lib, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ========================================================================
    # CORE CLI UTILITIES
    # ========================================================================
    wget                  # File downloader
    curl                  # URL transfer tool
    unzip
    p7zip
    usbutils              # USB utilities (lsusb)
    nvtopPackages.intel   # Hardware info
    imv                   # Image viewer
    jaq                   # JSON processor (jq alternative)
    matugen               # Material Design color generation
    lvm2
    git
    xwayland-satellite
    # ========================================================================
    # FILE MANAGEMENT CLI
    # ========================================================================
    eza                   # Modern ls replacement
    bat                   # Better cat with syntax highlighting
    ripgrep               # Fast grep alternative
    fd                    # Fast find alternative

    # ========================================================================
    # CLIPBOARD UTILITIES
    # ========================================================================
    wl-clipboard          # Wayland clipboard utilities
    wl-clipboard-rs       # Rust implementation
    cliphist              # Clipboard history manager
    clipboard-jh          # Another clipboard manager

    # ========================================================================
    # UTILITIES & COMPRESSION
    # ========================================================================
    zstd                  # Compression utility
    age                   # Modern encryption tool
    dig                   # DNS lookup utility
    tldr                  # Simplified man pages
    xdg-utils
    ueberzugpp
    dosfstools
    evtest
    electron
    # ========================================================================
    # SYSTEM GUI APPLICATIONS
    # ========================================================================
    networkmanagerapplet  # Network manager applet

    # ========================================================================
    # AUDIO SYSTEM PACKAGES
    # ========================================================================
    pipewire              # PipeWire CLI tools
    wireplumber           # PipeWire session manager
    jack2                 # JACK audio connection kit
    cava                  # Console audio visualizer
    libsixel              # Sixel graphics library
    alsa-utils            # ALSA utilities (alsamixer, amixer, etc.)
    # bluez                 # Bluetooth protocol stack (configured in hardware.nix)
    bluez-tools           # Bluetooth tools

    # ========================================================================
    # SYSTEM MONITORING & MANAGEMENT
    # ========================================================================
    lm_sensors            # Hardware temperature monitoring
    ananicy-rules-cachyos_git  # CPU scheduling rules for improved system performance
    brightnessctl         # Brightness control
    gammastep             # Screen temperature adjustment
    wlsunset              # Day/night gamma adjustments
    #libnotify             # Desktop notifications

    # ========================================================================
    # SYSTEM UTILITIES & TOOLS
    # ========================================================================
    #cryptsetup            # Disk encryption utilities
    ffmpeg
    nix-output-monitor    # Better build output
    nvd                   # Nix version diff tool
    nh
    libsecret
    glib
    appimage-run          # Needed for AppImage support
    libisoburn
    catnest

    # ========================================================================
    # FILE SYSTEM TOOLS
    # ========================================================================
    btrfs-progs           # Btrfs utilities
    f2fs-tools            # F2fs utilities
    btrfs-assistant
    busybox               # Core utilities replacement
    mimalloc
    bees
    compsize

    # ========================================================================
    # SCREENSHOT & RECORDING
    # ========================================================================
    grim                  # Screenshot utility
    slurp                 # Region selector for screenshots
    wl-screenrec          # Screen recorder
    swappy                # Screenshot editor

    # ========================================================================
    # NETWORK & SECURITY
    # ========================================================================
    nmap                  # Network scanner
    wireshark             # Network protocol analyzer
    apparmor-utils        # AppArmor profile tools
    apparmor-profiles     # Additional AppArmor profiles
    tpm2-tools            # TPM2 utilities
    lynis                 # Security auditing tool

    # ========================================================================
    # MISCELLANEOUS
    # ========================================================================
    seatd
    mods
    pciutils
    tinygettext

    # ========================================================================
    # KDE APPLICATIONS
    # ========================================================================
    kdePackages.dolphin     # KDE file manager
    kdePackages.kate        # KDE text editor

    # ========================================================================
    # AUDIO & MULTIMEDIA GUI
    # ========================================================================
    pavucontrol           # PulseAudio/PipeWire volume control
    pwvucontrol           # Native PipeWire volume control
    easyeffects           # Audio effects for PipeWire
    qpwgraph              # Qt-based PipeWire graph manager

    # ========================================================================
    # SYSTEM MONITORING & INFORMATION
    # ========================================================================
    btop                  # Modern resource monitor
    fastfetch             # System information display

    # ========================================================================
    # LLVM/CLANG TOOLCHAIN
    # ========================================================================
    llvm                  # LLVM compiler infrastructure
    clang                 # LLVM C/C++/Objective-C compiler
    llvmPackages.clang-unwrapped
    llvmPackages.clang-tools
    llvm-manpages
    libllvm
    llvmPackages.libc-full
    llvmPackages.libllvm
    llvmPackages.stdenv
    libclang
    llvmPackages.bintools
    llvmPackages.compiler-rt
    llvmPackages.libcxxClang
    llvmPackages.clangUseLLVM
    mold                  # Linker (faster than lld)
    flang                 # Fortran frontend for LLVM

    # ========================================================================
    # RUST TOOLCHAIN
    # ========================================================================
    rustc

    # ========================================================================
    # LANGUAGE SERVERS (CLI TOOLS)
    # ========================================================================
    nixd                  # Fast Nix LSP

    # ========================================================================
    # RUNTIME ENVIRONMENTS
    # ========================================================================
    python315            # Python runtime
    python313Packages.pip
    nodejs
    bun

    # ========================================================================
    # BUILD SYSTEMS
    # ========================================================================
    meson
    cmake
    binutils
    #libtool               # libtool replacement
    samurai               # Ninja replacement

    # ========================================================================
    # SHELL ENHANCEMENTS
    # ========================================================================
    zoxide                # Smarter cd command
    carapace              # Multi-shell completion
    inshellisense         # IDE-like shell completions
    fzf                   # Fuzzy finder

    # ========================================================================
    # VIRTUALIZATION - VM MANAGEMENT
    # ========================================================================
    virt-viewer           # Virtual machine viewer
    virt-top              # Monitor VM performance
    looking-glass-client  # Low-latency VM display
    scream                # Audio over VM

    # ========================================================================
    # QEMU/KVM SUPPORT
    # ========================================================================
    OVMF                  # UEFI firmware for VMs
    swtpm                 # TPM emulation
    libguestfs            # VM disk tools
    freerdp               # RDP client

    # ========================================================================
    # SPICE PROTOCOL SUPPORT
    # ========================================================================
    spice                 # SPICE protocol support
    spice-gtk             # SPICE client GTK
    spice-protocol        # SPICE protocol headers
    virglrenderer         # Virtual GPU support
    virtio-win            # Windows drivers for QEMU
    spice-vdagent         # SPICE guest agent
    spice-autorandr       # Auto display resize

    # ========================================================================
    # VULKAN - GRAPHICS & COMPUTE
    # ========================================================================
    vulkan-volk           # Vulkan loader
    vulkan-memory-allocator  # GPU memory allocation
    vulkan-utility-libraries # Vulkan utility functions
    vk-bootstrap          # Vulkan initialization helper
    vkd3d                 # Direct3D 12 to Vulkan
    vkdt                  # Vulkan image editor
    vkbasalt              # Vulkan shader layers
    vkdevicechooser       # GPU device selector
    vulkan-extension-layer # Vulkan extension layer

    # ========================================================================
    # QT5 COMPATIBILITY
    # ========================================================================
    libsForQt5.qt5.qtgraphicaleffects 
    kdePackages.qtquick3d
    python313Packages.pyqt6-webengine
    kdePackages.qtwebengine
    kdePackages.qtimageformats
    kdePackages.qtmultimedia
    # ========================================================================
    # WAYLAND & DISPLAY
    # ========================================================================
    wayland                              # Wayland protocol libraries
    wayland-utils                        # Wayland utilities (wayland-info, etc.)
    wayland-protocols                    # Wayland protocol extensions
    wtype
    wlr-randr
    wev
    wdisplays             # GUI display configurator
    kanshi                # Dynamic display configuration
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    python313Packages.anyqt

    # ========================================================================
    # MISCELLANEOUS SYSTEM PACKAGES
    # ========================================================================
    elogind
    material-symbols
    biome
    libsixel
  ];

  # ========================================================================
  # SYSTEM SHELLS
  # ========================================================================
  environment.shells = with pkgs; [
    nushell
    zsh
    fish
    bash
  ];

  # ========================================================================
  # NIX-LD - DYNAMIC LINKER FOR NIXOS
  # ========================================================================
  # Allows running dynamically linked binaries on NixOS
  # ========================================================================
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib-ng               # zlib replacement with multithreading
      openssl
      libGL
      SDL2
      libusb1
      libkrb5
      keyutils
      glibc
      libressl
      dbus-broker
      fuse3
      vulkan-loader
      vulkan-headers
      vulkan-tools

      # ====================================================================
      # QT LIBRARIES
      # ====================================================================
      qt6.qtwayland
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtsvg
      qt6.qt5compat
      qt6.qtquick3d
      qt6Packages.qt6ct
    ];
  };

  # ========================================================================
  # FONTS
  # ========================================================================
  fonts.packages = with pkgs; [
    # --- Core Fonts ---
    noto-fonts                    # Google Noto fonts (extensive language support)
    noto-fonts-cjk-sans           # Chinese, Japanese, Korean
    noto-fonts-color-emoji        # Color emoji support

    # --- System Fonts ---
    dejavu_fonts                  # DejaVu font family
    liberation_ttf                # Liberation fonts (Microsoft font alternatives)
    #adwaita-fonts                 # GNOME system font

    # --- Monospace Fonts (Programming) ---
    fira-code                     # Fira Code with ligatures
    fira-code-symbols             # Fira Code symbols
    jetbrains-mono                # JetBrains Mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.symbols-only       # Vital for Glyphs/Icons in Waybar/Terminal
    nerd-fonts.zed-mono

    # --- Special Purpose Fonts ---
    font-awesome                  # Font Awesome icons
    material-symbols              # Material Design symbols
    material-icons                # Material Design icons
    terminus_font                 # Terminus bitmap font

    # --- Additional Fonts ---
    inter                         # Inter font family
  ];

  # ========================================================================
  # FONT CONFIGURATION
  # ========================================================================
  fonts.fontconfig = {
    enable = true;

    # --- Antialiasing ---
    antialias = true;

    # --- Hinting ---
    hinting = {
      enable = true;
      autohint = false;
      style = "full";             # Options: none, slight, medium, full
    };

    # --- Subpixel Rendering ---
    subpixel = {
      lcdfilter = "default";      # LCD filter for subpixel rendering
      rgba = "rgb";               # Subpixel layout: rgb, bgr, vrgb, vbgr
    };

    # --- Default Fonts ---
    defaultFonts = {
      serif = [
        "Noto Serif"
        "DejaVu Serif"
        "Liberation Serif"
      ];

      sansSerif = [
        "Adwaita Sans"
        "Noto Sans"
        "DejaVu Sans"
        "Liberation Sans"
      ];

      monospace = [
        "GeistMono Nerd Font Mono"
        "JetBrainsMono Nerd Font Mono"
        "FiraCode Nerd Font Mono"
        "Fira Code"
        "JetBrains Mono"
      ];

      emoji = [
        "Noto Color Emoji"
      ];
    };

    # --- Local Configuration ---
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <!-- Emoji font preferences -->
        <alias>
          <family>emoji</family>
          <prefer>
            <family>Noto Color Emoji</family>
          </prefer>
        </alias>

        <!-- Symbol font preferences -->
        <alias>
          <family>monospace</family>
          <prefer>
            <family>Symbols Nerd Font</family>
          </prefer>
        </alias>
      </fontconfig>
    '';
  };

  fonts.fontDir = {
    enable = true;
    decompressFonts = true;
  };
  fonts.enableDefaultPackages = false;
}
