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
