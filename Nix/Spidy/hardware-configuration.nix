# /etc/nixos/SpidyNix/Nix/Spidy/hardware-configuration.nix
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ============================================================================
  # BOOT & KERNEL
  # ============================================================================
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  # ============================================================================
  # FILESYSTEMS: ROOT DRIVE (mock-noxian) - NO ENCRYPTION
  # ============================================================================
  fileSystems."/" = {
    device = "/dev/mapper/mock-noxian";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd:4" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/mock-noxian";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:5" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/mock-noxian";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd:4" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/mapper/mock-noxian";
    fsType = "btrfs";
    options = [ "subvol=persist" "compress-force=zstd:7" "noatime" ];
  };

  # Top-level subvol for emergency management
  fileSystems."/flat" = {
    device = "/dev/mapper/mock-noxian";
    fsType = "btrfs";
    options = [ "subvolid=5" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/92C1-A920";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  # ============================================================================
  # FILESYSTEMS: MOTIVATION DRIVE (mock-motivation) - NO ENCRYPTION
  # ============================================================================

  # 1. Computer: General storage
  fileSystems."/media/motivation/Computer" = {
    device = "/dev/mapper/mock-motivation";
    fsType = "btrfs";
    options = [ "subvol=Computer" "compress-force=zstd:7" "noatime" ];
  };

  # 2. Games: No Copy-on-Write for performance (reduces fragmentation on large game files)
  fileSystems."/media/motivation/Games" = {
    device = "/dev/mapper/mock-motivation";
    fsType = "btrfs";
    options = [ "subvol=Games" "nodatacow" "noatime" "compress-force=zstd:5" ];
  };

  # 3. Media: Standard compression (Videos/Images usually don't compress well)
  fileSystems."/media/motivation/Media" = {
    device = "/dev/mapper/mock-motivation";
    fsType = "btrfs";
    options = [ "subvol=Media" "compress-force=zstd:6" "noatime" ];
  };

  # 4. Temp: Low compression for speed
  fileSystems."/media/motivation/Temp" = {
    device = "/dev/mapper/mock-motivation";
    fsType = "btrfs";
    options = [ "subvol=Temp" "compress=zstd:1" "noatime" ];
  };

  # 5. Learning: High compression (Text, PDFs, Books compress well)
  fileSystems."/media/motivation/Learning" = {
    device = "/dev/mapper/mock-motivation";
    fsType = "btrfs";
    options = [ "subvol=Learning" "compress-force=zstd:9" "noatime" ];
  };

  # 6. Edit: Balanced
  fileSystems."/media/motivation/Edit" = {
    device = "/dev/mapper/mock-motivation";
    fsType = "btrfs";
    options = [ "subvol=Edit" "compress-force=zstd:7" "noatime" ];
  };

  # ============================================================================
  # SWAP & PLATFORM
  # ============================================================================
  swapDevices = [
    { device = "/dev/mapper/mock-fang"; }
  ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
