# /etc/nixos/SpidyNix/Nix/Spidy/hardware-configuration.nix
{ config, lib, pkgs, modulesPath, ... }:
{
  # Import hardware detection modules
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")  # Fallback for undetected hardware
  ];

  # ============================================================================
  # BOOT CONFIGURATION
  # ============================================================================
  boot = {
    # Initial RAM filesystem modules
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" "i915" "dm-crypt" "dm-mod" "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" "kvm" ];
    };

    # Additional kernel modules
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];  # Additional kernel module packages
  };

  # ============================================================================
  # FILESYSTEM CONFIGURATION
  # ============================================================================
  fileSystems = {
    # Root filesystem
    "/" = {
      device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd:3" "noatime" ];
    };

    # Home filesystem
    "/home" = {
      device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:5" "noatime" ];
    };

    # Nix filesystem
    "/nix" = {
      device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd:4" "noatime" ];
    };

    # Persistent filesystem
    "/persist" = {
      device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd:6" "noatime" ];
    };

    # Boot filesystem
    "/boot" = {
      device = "/dev/disk/by-uuid/5C8E-D52D";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    # Additional filesystem
    "/media/motivation" = {
      device = "/dev/mapper/mock-motivation";
      fsType = "btrfs";
      options = [ "compress=zstd:7" "noatime" ];
    };
    "/flat" = {
      device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvolid=5" ];
    };
  };

  # ============================================================================
  # SWAP CONFIGURATION
  # ============================================================================
  swapDevices = [
    {
      device = "/dev/mapper/mock-fang";
    }
  ];

  # ============================================================================
  # HARDWARE PLATFORM
  # ============================================================================
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";  # Set host platform

  # ============================================================================
  # CPU CONFIGURATION
  # ============================================================================
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;  # Enable Intel microcode updates
}
# ============================================================================
# HARDWARE CONFIGURATION
# ============================================================================
# This file defines the hardware configuration for the 'Spidy' host.
# It includes boot settings, filesystem configuration, swap devices, and CPU settings.
# ============================================================================
# NOTES:
# - This configuration sets up the hardware-specific settings for the system
# - Includes boot modules, filesystem mounts, and swap configuration
# - For troubleshooting:
#   - Check boot modules: lsmod | grep <module>
#   - Verify filesystem mounts: mount | grep btrfs
#   - Check swap status: swapon --show
# - To customize:
#   - Add/remove boot modules as needed
#   - Adjust filesystem compression settings
#   - Change swap device priority
# ============================================================================
