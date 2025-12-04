# /etc/nixos/SpidyNix/Softwares/software.nix
{ config, pkgs, ... }:
{
  # ============================================================================
  # SOFTWARE CONFIGURATION HUB
  # ============================================================================
  # This file serves as the central hub for all software configurations.
  # It imports and organizes all software-related modules in a structured manner.
  # ============================================================================
  imports = [
    ./basic.nix
    ./font.nix
    ./program.nix
    #./virtualization.nix
    ./wayland.nix
  ];
}
