{ config, pkgs, lib, inputs, ... }:

{
  # ========================================================================
  # LIBVIRTD - VIRTUALIZATION DAEMON
  # ========================================================================
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "start";
    onShutdown = "shutdown";

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;

      verbatimConfig = ''
        ${builtins.readFile ./virtualization.nix}
        
        #  Hide hypervisor
        # Uncomment in your VM XML: <kvm><hidden state="on"/></kvm>
        
        # GPU Passthrough requirements:
        # 1. Enable IOMMU in boot.nix (already done with iommu=pt)
        # 2. Create IOMMU groups for your GPU
        # 3. Use vfio driver instead of native driver
        # 4. Bind GPU to vfio-pci in the VM XML
        
        # Example VM XML for GPU passthrough:
        # <hostdev mode="subsystem" type="pci" managed="yes">
        #   <source>
        #     <address domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
        #   </source>
        # </hostdev>
        
        user = "qemu-libvirtd"
        group = "kvm"
        dynamic_ownership = 1
        remember_owner = 0
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
