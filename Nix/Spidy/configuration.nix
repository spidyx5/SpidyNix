# Spidy Profile Configuration
# This file contains the main configuration for the Spidy profile

{ inputs, lib, config, pkgs, ... }:

{
  # Import the profile configuration
  imports = [
    ./spidy-profile.nix
    ./hardware-configuration.nix
  ];

  # System configuration
  system.stateVersion = "26.05";  # Version of NixOS this configuration is designed for
  
  # Hardware configuration is imported above
  
  # Profile-specific settings are in spidy-profile.nix
  
  # You can add additional system-wide configuration here
  # Examples:
  # - Networking
  # - Services  
  # - Packages
  # - System settings
}