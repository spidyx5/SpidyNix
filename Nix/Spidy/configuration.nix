# /etc/nixos/SpidyNix/Nix/Spidy/configuration.nix
{ inputs, lib, config, pkgs, ... }:

{
  # Import the profile configuration
  imports = [
    ./spidy-profile.nix
    ./hardware-configuration.nix
  ];

  # System configuration
  system.stateVersion = "26.05"; 
}