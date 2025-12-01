# /etc/nixos/SpidyNix/Homes/packages/desktop.nix
{ config, lib, pkgs, inputs, ... }:

{
  # ============================================================================
  # DESKTOP GUI APPLICATIONS
  # ============================================================================
  # User-level desktop applications and utilities
  # ============================================================================
  home.packages = with pkgs; [
    # ==========================================================================
    # PASSWORD MANAGERS & SECURITY GUI
    # ==========================================================================
    bitwarden-desktop     # Password manager
    bitwarden-menu        # Bitwarden menu applet
    protonvpn-gui         # Proton VPN GUI client
    protonmail-desktop    # Proton Mail desktop app
    proton-authenticator  # Proton authenticator
    protonmail-bridge-gui # Proton Mail Bridge GUI

    # ==========================================================================
    # UTILITIES
    # ==========================================================================
    calibre-web           # Calibre web interface
    yt-dlp                # YouTube downloader
    parabolic
    qbittorrent           # Torrent client
    # ==========================================================================
    # NETWORKING & SECURITY
    # ==========================================================================
    openvpn               # OpenVPN client

    # ==========================================================================
    # MULTIMEDIA & CONTENT
    # ==========================================================================
    spotify               # Music streaming client
    calibre               # E-book management
    foliate               # E-book reader
    libgen-cli            # Library Genesis CLI
    equibop               # Discord
    dopamine
    smplayer
    vlc
    niri-unstable

    # ==========================================================================
    # BROWSERS
    # ==========================================================================
    widevine-cdm          # Widevine DRM support
    gemini-cli            # Google Gemini AI CLI

    # ==========================================================================
    # CONTAINER & VIRTUALIZATION CLI
    # ==========================================================================
    distrobox             # Containerized development environment
    podman                # Podman CLI
    podman-compose
    winboat
  ];
}
# ============================================================================
# DESKTOP APPLICATIONS CONFIGURATION
# ============================================================================
# This file contains user-level desktop applications
# Home Manager module for user 'spidy'
# ============================================================================
# NOTES:
# - This configuration provides desktop applications
# - Applications are organized by functionality
# - For troubleshooting:
#   - Check installation: which APP_NAME
#   - Verify desktop integration: echo $XDG_CURRENT_DESKTOP
# - To customize:
#   - Add/remove applications as needed
# ============================================================================
