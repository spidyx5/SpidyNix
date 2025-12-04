# /etc/nixos/SpidyNix/Softwares/virtualization.nix
{ config, pkgs, lib, inputs, ... }:
{
  # ============================================================================
  # LIBVIRT - VIRTUAL MACHINE MANAGEMENT
  # ============================================================================
    # KVM virtualization with QEMU backend
    virtualisation.libvirtd = {
    enable = true;                     # Enable libvirtd service

    # Start libvirtd on boot
    onBoot = "start";                  # Start libvirtd on system boot

    # Shutdown VMs gracefully on host shutdown
    onShutdown = "shutdown";           # Graceful VM shutdown on host shutdown

    # QEMU configuration
    qemu = {
      # Use KVM package for hardware virtualization
      package = pkgs.qemu_kvm;         # Use KVM-enabled QEMU

      # Run QEMU as regular user (more secure)
      runAsRoot = true;               # Run QEMU as root for better permissions

      # Software TPM emulation
      swtpm.enable = true;             # Enable software TPM emulation
     # secureBoot   = true;             # Enable Secure Boot

      # Custom QEMU configuration
      verbatimConfig = ''
        user = "qemu-libvirtd"         # Run as qemu-libvirtd user
        group = "kvm"                   # Use kvm group
        dynamic_ownership = 1          # Enable dynamic ownership
        remember_owner = 0             # Don't remember owner
        ga = "enabled"                 # Enable QEMU guest agent channel
      '';
    };

    # Allowed network bridges
    allowedBridges = [
      "virbr0"    # Default NAT bridge
      "br0"       # Custom bridge (if needed)
    ];
  };

    # DOCKER CONFIGURATION
    # virtualisation.docker = lib.mkIf config.virtualizationTools.docker {
    #   enable = true;                    # Enable Docker

    #   # Enable on boot
    #   enableOnBoot = false;            # Don't start Docker on boot

    #   # Storage driver
    #   storageDriver = "overlay2";       # Use overlay2 storage driver

    #   # Auto-prune resources
    #   autoPrune = {
    #     enable = true;                 # Enable auto-prune
    #     dates = "weekly";               # Run weekly
    #   };
    # };

    # PODMAN CONFIGURATION
    virtualisation.podman = {
    enable = true;                    # Enable Podman

    # Create a "docker" alias for podman
    dockerCompat = true;             # Don't create docker alias

    # Make the Podman socket available at /var/run/docker.sock
    dockerSocket.enable = true;     # Don't enable Docker socket

    # Enable the DNS plugin for the default network
    defaultNetwork.settings.dns_enabled = true;  # Enable DNS for containers

    # Auto-prune (cleanup)
    autoPrune = {
      enable = true;                 # Enable auto-prune
      dates = "weekly";               # Run weekly
      flags = [ "--all" ];            # Remove all unused images
    };
  };

    # SPICE USB REDIRECTION
    virtualisation.spiceUSBRedirection.enable = true;  # Enable SPICE USB redirection


    # VM STORAGE DIRECTORIES
    systemd.tmpfiles.rules = [
      # ISO storage directory
      "d /var/lib/libvirt/isos 0755 qemu-libvirtd kvm -"

      # VM disk images directory
      "d /var/lib/libvirt/images 0755 qemu-libvirtd kvm -"

      # VM snapshots directory
      "d /var/lib/libvirt/snapshots 0755 qemu-libvirtd kvm -"
    ];

    # WAYDROID CONFIGURATION
    virtualisation.waydroid.enable = true;

    # SHELL ALIASES
    environment.shellAliases = {
      waydroid-stop = "sudo waydroid container stop | waydroid session stop";
    };
}
