{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  # =========================================================================
  # OVERLAYS
  # =========================================================================
  nixpkgs.overlays = [
    (import ../Systems/overlay.nix)
  ];

  imports = [
    ../Systems/boot.nix
    ../Systems/nixos.nix
    ../Systems/service.nix
    ../Systems/hardware.nix
    ../Systems/basic.nix
    ../Systems/program.nix
    ../Systems/virtualization.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.dankMaterialShell.nixosModules.greeter
  ];

  # =========================================================================
  # HOME MANAGER CONFIGURATION
  # =========================================================================
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";

    users.spidy = {
      imports = [
        ../Homes/home.nix
      ];
    };
  };

  # =========================================================================
  # SYSTEM STATE VERSION
  # =========================================================================
  system.stateVersion = "26.05";

  # =========================================================================
  # KERNEL & HARDWARE SUPPORT
  # =========================================================================
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # =========================================================================
  # FILESYSTEMS: SYSTEM DRIVE (mock-noxian)
  # =========================================================================

  fileSystems."/" =
    { device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd:4" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:5" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd:4" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress-force=zstd:7" "noatime" ];
    };

  fileSystems."/flat" =
    { device = "/dev/mapper/mock-noxian";
      fsType = "btrfs";
      options = [ "subvolid=5" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9F1A-7575";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  # =========================================================================
  # FILESYSTEMS: MOTIVATION DRIVE (mock-motivation)
  # =========================================================================

  fileSystems."/media/motivation/Computer" =
    { device = "/dev/mapper/mock-motivation";
      fsType = "btrfs";
      options = [ "subvol=Computer" "compress-force=zstd:7" "noatime" ];
    };

  fileSystems."/media/motivation/Games" =
    { device = "/dev/mapper/mock-motivation";
      fsType = "btrfs";
      options = [ "subvol=Games" "nodatacow" "noatime" "compress-force=zstd:5" ];
    };

  fileSystems."/media/motivation/Media" =
    { device = "/dev/mapper/mock-motivation";
      fsType = "btrfs";
      options = [ "subvol=Media" "compress-force=zstd:6" "noatime" ];
    };

  fileSystems."/media/motivation/Temp" =
    { device = "/dev/mapper/mock-motivation";
      fsType = "btrfs";
      options = [ "subvol=Temp" "compress=zstd:1" "noatime" ];
    };

  fileSystems."/media/motivation/Learning" =
    { device = "/dev/mapper/mock-motivation";
      fsType = "btrfs";
      options = [ "subvol=Learning" "compress-force=zstd:9" "noatime" ];
    };

  fileSystems."/media/motivation/Edit" =
    { device = "/dev/mapper/mock-motivation";
      fsType = "btrfs";
      options = [ "subvol=Edit" "compress-force=zstd:7" "noatime" ];
    };

  # =========================================================================
  # SWAP
  # =========================================================================
  swapDevices = [ { device = "/dev/mapper/mock-fang"; } ];

  # =========================================================================
  # SYSTEM PLATFORM
  # =========================================================================
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
