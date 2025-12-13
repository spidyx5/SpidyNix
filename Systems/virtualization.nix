{ config, pkgs, lib, inputs, ... }:

{
  # ========================================================================
  # GUI & FIREWALL (Required for functional VMs)
  # ========================================================================
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # ========================================================================
  # LIBVIRTD - VIRTUALIZATION DAEMON
  # ========================================================================
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "start";
    onShutdown = "shutdown";

    qemu = {
      package = pkgs.qemu_kvm;

      # Run as root (as you requested)
      runAsRoot = true;
      swtpm.enable = true;


      verbatimConfig = ''
        # GPU Passthrough requirements:
        # 1. Enable IOMMU in boot.nix (iommu=pt)
        # 2. Bind GPU to vfio-pci

        # Ownership settings for running as root
        dynamic_ownership = 0
        remember_owner = 0

        # Guest Agent
        ga = "enabled"
      '';
    };

    allowedBridges = [
      "virbr0"
      "br0"
    ];
  };

  # ========================================================================
  # PODMAN - CONTAINER ENGINE
  # ========================================================================
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;

    defaultNetwork.settings.dns_enabled = true;

    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  # ========================================================================
  # SPICE USB REDIRECTION
  # ========================================================================
  virtualisation.spiceUSBRedirection.enable = true;


  # ========================================================================
  # WAYDROID - ANDROID CONTAINER
  # ========================================================================
  virtualisation.waydroid.enable = true;

  # ========================================================================
  # SHELL ALIASES
  # ========================================================================
  environment.shellAliases = {
    waydroid-stop = "sudo waydroid container stop | waydroid session stop";
  };
}
