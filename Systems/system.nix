# /etc/nixos/SpidyNix/Systems/system.nix
{ config, pkgs, lib, ... }:

#let
  # Define a local variable pointing to the overlay function
 # aggressiveStdenvOverlay = import ./overlay.nix; 
#in
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

  # CORRECT: Apply the overlay using the dedicated NixOS option
 # nixpkgs.overlays = [
  #  aggressiveStdenvOverlay
  #];
}
