{ config, pkgs, lib, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ========================================================================
    # SECURITY & PASSWORD MANAGEMENT
    # ========================================================================
    bitwarden-desktop     # Password manager
    bitwarden-menu        # Bitwarden menu applet
    protonvpn-gui         # Proton VPN GUI client
    protonmail-desktop    # Proton Mail desktop app
    proton-authenticator  # Proton authenticator
    protonmail-bridge-gui # Proton Mail Bridge GUI

    # ========================================================================
    # VPN & NETWORKING
    # ========================================================================
    openvpn               # OpenVPN client

    # ========================================================================
    # UTILITIES & DOWNLOADERS
    # ========================================================================
    calibre-web           # Calibre web interface
    yt-dlp                # YouTube downloader
    parabolic             # YouTube video downloader GUI
    qbittorrent           # Torrent client

    # ========================================================================
    # MULTIMEDIA & CONTENT
    # ========================================================================
    calibre               # E-book management
    foliate               # E-book reader
    libgen-cli            # Library Genesis CLI
    equibop               # Discord integration
    dopamine              # Music player
    smplayer              # Video player
    spotify               # Music player
    
    # ========================================================================
    # BROWSERS & WEB
    # ========================================================================
    widevine-cdm          # Widevine DRM support
    gemini-cli            # Google Gemini AI CLI

    # ========================================================================
    # CONTAINER & VIRTUALIZATION
    # ========================================================================
    distrobox             # Containerized development environment
    podman-compose
    winboat               # Wine/Proton GUI

    # ========================================================================
    # AUDIO PRODUCTION
    # ========================================================================
    reaper                # Digital Audio Workstation
    reaper-sws-extension  # Reaper extension
    reaper-reapack-extension  # Reaper package manager

    # ========================================================================
    # DIGITAL ART & DESIGN
    # ========================================================================
    krita                 # Digital painting
    blender               # 3D modeling & animation

    # ========================================================================
    # NOTE-TAKING & KNOWLEDGE MANAGEMENT
    # ========================================================================
    obsidian              # Note-taking app

    # ========================================================================
    # VIDEO EDITING
    # ========================================================================
    davinci-resolve-studio # DaVinci Resolve Studio
    
    #quickshell
    # Gaming overlays and tools
    mangohud              # Gaming overlay for FPS/performance
    gamescope             # Gaming compositor
    jstest-gtk            # Joystick testing tool
    antimicrox            # Controller to keyboard/mouse mapper
    #proton-cachyos_nightly_x86_64_v3
    twitch-hls-client
    obs-studio-plugins.obs-vkcapture

    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    #inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # ========================================================================
  # VIRTUALIZATION - VIRT-MANAGER
  # ========================================================================
  programs.virt-manager.enable = true;
  programs.spicetify.enable = true;
  
  programs.dankMaterialShell.greeter = {
  compositor = {
    name = "niri"; # Required. Can be also "hyprland" or "sway"
    customConfig = ''
      # Optional custom compositor configuration
    '';
  };

  # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
  configHome = "/home/spidy";

  # Custom config files for non-standard config locations
  configFiles = [
    "/home/spidy/.config/DankMaterialShell/settings.json"
  ];

  # Save the logs to a file
  logs = {
    save = true; 
    path = "/tmp/dms-greeter.log";
  };
};
  # ========================================================================
  # ANDROID DEBUG BRIDGE (ADB)
  # ========================================================================
  programs.adb.enable = true;

  # ========================================================================
  # CHAOTIC-AUR INTEGRATION
  # ========================================================================
  chaotic.nyx.cache.enable = true;
  chaotic.nyx.nixPath.enable = true;
  chaotic.nyx.overlay.enable = true;
  chaotic.nyx.registry.enable = true;

  # ========================================================================
  # DIRENV - AUTOMATIC ENVIRONMENT SWITCHING
  # ========================================================================
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  # ========================================================================
  # NIX-INDEX - PACKAGE LOOKUP UTILITY
  # ========================================================================
  programs.nix-index.enable = true;

  # ========================================================================
  # FUSE - FILESYSTEM IN USERSPACE
  # ========================================================================
  # Allow non-root users to mount filesystems
  # ========================================================================
  programs.fuse.userAllowOther = true;

  # ========================================================================
  # STEAM - GAMING PLATFORM
  # ========================================================================
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin                   # Proton GE for better compatibility
    ];
    platformOptimizations.enable = true;
  };

  # ========================================================================
  # XDG DESKTOP PORTAL CONFIGURATION
  # ========================================================================
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [ "gtk" ];
      };
      niri = {
        default = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };
}
