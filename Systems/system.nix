# /etc/nixos/SpidyNix/Systems/system.nix
{ config, pkgs, lib, ... }:
{
  # Imports all core system configuration modules in the Systems folder.
  imports = [
    ./blacklist.nix
    ./boot.nix
    ./hardware.nix
    ./login.nix
    ./network.nix
    ./nixos.nix
    ./power.nix
    ./security.nix
    ./service.nix
    ./sound.nix
    ./user.nix
  ];
}
# ============================================================================
# IMPORTED MODULES
# ============================================================================
# This file imports all core system configuration modules in the Systems folder.
# Each imported module configures a specific aspect of the system:
#
# blacklist.nix     - Blacklisted kernel configuration
# boot.nix          - Kernel configuration
# hardware.nix      - Driver related configuration
# home-manager.nix  - Service enablement for Home Manager
# login.nix         - Login manager configuration
# network.nix       - Network and firewall configuration
# nixos.nix         - General NixOS options (e.g., GC, Nix settings)
# power.nix         - Performance and power management configuration
# security.nix      - Security configuration
# service.nix       - Systemd services configuration
# sound.nix         - Wired and wireless sound configuration
# user.nix          - User definitions and groups configuration
#
# This modular approach allows for better organization and maintainability
# of the system configuration.
# ============================================================================
