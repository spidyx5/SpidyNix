# /etc/nixos/SpidyNix/Homes/packages/productive.nix
{ config, lib, pkgs, ... }:

{
  # ============================================================================
  # PRODUCTIVITY APPLICATIONS
  # ============================================================================
  # Creative and productivity software
  # ============================================================================
  home.packages = with pkgs; [
    # ==========================================================================
    # AUDIO PRODUCTION
    # ==========================================================================
    reaper                # Digital Audio Workstation
    reaper-sws-extension  # Reaper extension
    reaper-reapack-extension  # Reaper package manager

    # ==========================================================================
    # DIGITAL ART & DESIGN
    # ==========================================================================
    krita                 # Digital painting
    blender

    # ==========================================================================
    # NOTE-TAKING & KNOWLEDGE MANAGEMENT
    # ==========================================================================
    obsidian              # Note-taking app

    # ==========================================================================
    # VIDEO EDITING (Conditional)
    # ========================================================================= 
    #davinci-resolve-studio # DaVinci Resolve Studio
  ];
}
# ============================================================================
# PRODUCTIVITY APPLICATIONS CONFIGURATION
# ============================================================================
# This file contains creative and productivity software
# Home Manager module for user 'spidy'
# ============================================================================
# NOTES:
# - Choose either davinci-resolve OR davinci-resolve-studio
# - DaVinci Resolve Studio has additional features but requires license
# - For troubleshooting:
#   - Check installation: which APP_NAME
# - To customize:
#   - Enable/disable DaVinci variants in user-config.nix
# ============================================================================
