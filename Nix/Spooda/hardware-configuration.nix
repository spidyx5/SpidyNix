# /etc/nixos/SpidyNix/Nix/Spooda/hardware-configuration.nix
# Test hardware configuration for spooda host
# This is a template - replace with actual hardware configuration

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ============================================================================
  # TEST HARDWARE CONFIGURATION
  # ============================================================================
  # This is a minimal test hardware configuration
  # Replace with actual hardware scan results: nixos-generate-config
  # ============================================================================

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";  # Replace with actual UUID
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0000-0000";  # Replace with actual UUID
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000"; }  # Replace with actual UUID
  ];

  # Enables DHCP on each ethernet and wireless interface
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ============================================================================
  # TEST CONFIGURATION NOTES
  # ============================================================================
  # This is a template hardware configuration for testing
  # - Replace UUIDs with actual disk identifiers
  # - Run nixos-generate-config to get real hardware config
  # - Adjust kernel modules based on actual hardware
  # ============================================================================
}