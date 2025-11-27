# /etc/nixos/SpidyNix/Softwares/virtualization.nix
{ config, pkgs, lib, inputs, ... }:
{
  # LIBVIRT - VIRTUAL MACHINE MANAGEMENT
  # KVM virtualization with QEMU backend
  virtualisation.libvirtd = lib.mkIf config.virtualizationTools.libvirt {
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
  virtualisation.docker = lib.mkIf config.virtualizationTools.docker {
    enable = true;                    # Enable Docker

    # Enable on boot
    enableOnBoot = false;            # Don't start Docker on boot

    # Storage driver
    storageDriver = "overlay2";       # Use overlay2 storage driver

    # Auto-prune resources
    autoPrune = {
      enable = true;                 # Enable auto-prune
      dates = "weekly";               # Run weekly
    };
  };

  # PODMAN CONFIGURATION
  virtualisation.podman = lib.mkIf config.virtualizationTools.podman {
    enable = true;                    # Enable Podman

    # Create a "docker" alias for podman
    dockerCompat = false;             # Don't create docker alias

    # Make the Podman socket available at /var/run/docker.sock
    dockerSocket.enable = false;     # Don't enable Docker socket

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
  systemd.tmpfiles.rules = lib.mkIf config.virtualizationTools.libvirt [
    # ISO storage directory
    "d /var/lib/libvirt/isos 0755 qemu-libvirtd kvm -"

    # VM disk images directory
    "d /var/lib/libvirt/images 0755 qemu-libvirtd kvm -"

    # VM snapshots directory
    "d /var/lib/libvirt/snapshots 0755 qemu-libvirtd kvm -"
  ];

  # WAYDROID CONFIGURATION
  virtualisation.waydroid.enable = config.virtualizationTools.waydroid;

  # SHELL ALIASES
  environment.shellAliases = lib.mkIf config.virtualizationTools.waydroid {
    waydroid-stop = "sudo waydroid container stop | waydroid session stop";
  };
}

# ============================================================================
# VIRTUALIZATION CONFIGURATION NOTES
# ============================================================================
# This file configures virtualization support including:
#   - libvirt/QEMU/KVM for virtual machines
#   - Docker for containers
#   - SPICE for VM display
#   - USB redirection
#   - VM storage and networking
#   - Permissions and user access
# ============================================================================

# LIBVIRT:
# - Virtual machine management system
# - Supports: KVM, QEMU, Xen, LXC, etc.
# - GUI: virt-manager
# - CLI: virsh
# - Default network: 192.168.122.0/24 (NAT)

# VIRT-MANAGER:
# - GUI for managing VMs
# - Launch: virt-manager
# - Create VM: New VM button
# - Connect: qemu:///system
# - Preferences in Homes/vm.nix (via dconf)

# VIRSH COMMANDS:
# - List VMs: virsh list --all
# - Start VM: virsh start VM_NAME
# - Stop VM: virsh shutdown VM_NAME
# - Destroy VM: virsh destroy VM_NAME (force stop)
# - Delete VM: virsh undefine VM_NAME
# - Edit VM: virsh edit VM_NAME

# QEMU/KVM:
# - QEMU: Machine emulator and virtualizer
# - KVM: Kernel-based Virtual Machine (hardware virtualization)
# - Requires: Intel VT-x or AMD-V
# - Check: grep -E 'vmx|svm' /proc/cpuinfo

# VM STORAGE:
# - Location: /var/lib/libvirt/images/
# - Format: qcow2 (recommended), raw, vmdk
# - Snapshots: Only work with qcow2
# - ISOs: /var/lib/libvirt/isos/

# UEFI SUPPORT:
# - OVMF provides UEFI firmware
# - Required for: Windows 11, Secure Boot
# - Select firmware in VM settings
# - TPM emulation via swtpm

# NETWORKING:
# - NAT: Default network, VMs can access internet
# - Bridge: VMs appear on LAN (requires bridge setup)
# - Host-only: VMs can only talk to host
# - Create networks: virt-manager or virsh net-define

# DOCKER:
# - Container runtime
# - Commands: docker run, docker ps, docker stop, etc.
# - Images: docker pull IMAGE_NAME
# - Build: docker build -t NAME .
# - Compose: docker-compose up

# DOCKER VS PODMAN:
# - Docker: Traditional, daemon-based
# - Podman: Daemonless, rootless capable
# - Podman is Docker-compatible (alias docker=podman)
# - Enable only one, not both

# GPU PASSTHROUGH:
# - Pass physical GPU to VM
# - Requires: IOMMU, VFIO
# - Complex setup, see NixOS wiki
# - Best for single-GPU passthrough setups

# USB PASSTHROUGH:
# - Pass USB devices to VMs
# - SPICE USB redirection enabled
# - Or use virt-manager to add USB device
# - Hot-plug supported

# SPICE:
# - Display protocol for VMs
# - Features: Clipboard sharing, USB redirection
# - Better than VNC for desktop use
# - Remote access supported

# SNAPSHOTS:
# - Save VM state for easy rollback
# - Requires qcow2 disk format
# - Create: virsh snapshot-create VM_NAME
# - List: virsh snapshot-list VM_NAME
# - Restore: virsh snapshot-revert VM_NAME SNAPSHOT_NAME

# CLONING VMs:
# - virt-clone: Clone entire VM
# - virsh: virsh vol-clone (clone disk only)
# - GUI: Right-click VM > Clone in virt-manager

# VM TEMPLATES:
# - Create base VM with OS installed
# - Take snapshot before configuration
# - Clone for new VMs
# - Faster than reinstalling OS

# WINDOWS VMs:
# - Download ISO from Microsoft
# - Use UEFI firmware (OVMF)
# - Install virtio drivers for better performance
# - Download: https://fedorapeople.org/groups/virt/virtio-win/

# LINUX VMs:
# - Any distribution supported
# - virtio drivers usually included
# - Better performance than IDE/SATA

# PERFORMANCE:
# - Use virtio for disk and network
# - Enable KVM hardware virtualization
# - Allocate appropriate RAM (4GB+ for desktop OS)
# - Use host-passthrough CPU mode
# - Enable 3D acceleration if supported

# TROUBLESHOOTING:
# - VM won't start: Check logs with journalctl -u libvirtd
# - No network: Check virsh net-list --all
# - Slow performance: Enable virtio, KVM
# - Permission denied: Add user to libvirtd group
# - USB not working: Check SPICE USB redirection

# SECURITY:
# - VMs are isolated from host by default
# - NAT network isolates VMs from LAN
# - Don't run untrusted software in host
# - Regular VM snapshots for easy recovery
# - Keep VM OS updated

# BACKUPS:
# - VM disks: /var/lib/libvirt/images/
# - VM configs: /etc/libvirt/qemu/
# - Export VM: virsh dumpxml VM_NAME > vm.xml
# - Backup disk: cp /var/lib/libvirt/images/vm.qcow2 backup/

# AUTOMATION:
# - virsh: Scriptable CLI
# - virt-install: Create VMs from command line
# - Cloud-init: Automate VM provisioning
# - Terraform: Infrastructure as code

# NESTED VIRTUALIZATION:
# - Run VMs inside VMs
# - Enable: echo "options kvm_intel nested=1" > /etc/modprobe.d/kvm.conf
# - Check: cat /sys/module/kvm_intel/parameters/nested
# - Performance impact

# LIBVIRT NETWORKS:
# - Default: 192.168.122.0/24 (NAT)
# - List: virsh net-list --all
# - Start: virsh net-start default
# - Auto-start: virsh net-autostart default
# - Edit: virsh net-edit NETWORK_NAME

# STORAGE POOLS:
# - Default: /var/lib/libvirt/images
# - List: virsh pool-list --all
# - Create: virt-manager or virsh pool-define
# - Multiple pools for organization

# MONITORING:
# - virt-top: Top-like monitoring for VMs
# - virsh dominfo VM_NAME: VM information
# - virsh domstats VM_NAME: VM statistics
# - virt-viewer: Connect to VM display

# BEST PRACTICES:
# - Regular snapshots before changes
# - Use qcow2 for space efficiency
# - Allocate RAM conservatively
# - Use virtio for best performance
# - Keep VMs updated
# - Document VM purposes

# RESOURCES:
# - NixOS Wiki: https://nixos.wiki/wiki/Virt-manager
# - Libvirt docs: https://libvirt.org/
# - KVM docs: https://www.linux-kvm.org/
# - QEMU docs: https://www.qemu.org/docs/
# ============================================================================
