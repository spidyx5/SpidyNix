# /etc/nixos/SpidyNix/Nix/Spooda/configuration.nix
{ config, pkgs, lib, inputs, ... }:

{
  # Import hardware configuration
  imports = [
    ./hardware-configuration.nix
    ./spooda-profile.nix
    ../../Systems/system.nix
    ../../Systems/boot.nix
    ../../Systems/hardware.nix
    ../../Systems/login.nix
    ../../Systems/network.nix
    ../../Systems/nixos.nix
    ../../Systems/power.nix
    ../../Systems/security.nix
    ../../Systems/service.nix
    ../../Systems/sound.nix
    ../../Systems/user.nix
    ../../Softwares/software.nix
  ];

  # ============================================================================
  # SPOODA HOST CONFIGURATION
  # ============================================================================
  # Test configuration for spooda host
  # ============================================================================

  # Host-specific settings
  networking.hostName = "spooda";  # Hostname for this machine

  # Test packages
  environment.systemPackages = with pkgs; [
    hello          # Test package

  ];

  # Test service
  services.nginx = {
    enable = false;
  };
  system.stateVersion = "26.05";  # Set system state version
  # ============================================================================
  # TEST CONFIGURATION NOTES
  # ============================================================================
  # This is a minimal test configuration for the spooda host
  # ============================================================================
}
