# /etc/nixos/SpidyNix/Homes/configs/vm.nix
{ config, pkgs, lib, ... }:

lib.mkIf config.myConfig.virtualization {
  # ============================================================================
  # VIRTUALIZATION PACKAGES
  # ============================================================================
  # User-level virtualization and VM management tools
  # ============================================================================
  # ============================================================================
  # Virt-manager GUI preferences and VM defaults
  # ============================================================================
  dconf.settings = {
    # Virt-manager connections
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];  # Auto-connect to system QEMU
      uris = ["qemu:///system"];  # Available URIs
    };

    # Virt-manager general preferences
    "org/virt-manager/virt-manager" = {
      xmleditor-enabled = true;  # Enable XML editing for advanced configs
      stats-update-interval = 1;  # Update stats every second
      console-accels = true;  # Enable console accelerators
    };

    # VM viewer settings
    "org/virt-manager/virt-manager/console" = {
      resize-guest = 1;  # Automatically resize guest display
      scaling = 1;  # Scale to fit window
    };

    # Default VM settings
    "org/virt-manager/virt-manager/new-vm" = {
      graphics-type = "spice";  # Use SPICE for better performance
      cpu-default = "host-passthrough";  # Better CPU performance
      storage-format = "qcow2";  # Efficient disk format with snapshots
    };

    # ISO locations
    "org/virt-manager/virt-manager/urls" = {
      isos = ["/var/lib/libvirt/isos"];  # Default ISO location
    };
  };
}
# ============================================================================
# VIRTUALIZATION CONFIGURATION
# ============================================================================
# This file configures user-level virtualization tools and virt-manager preferences
# Home Manager module for user 'spidy'
# ============================================================================
# NOTES:
# - This configuration provides VM management tools and GUI preferences
# - Includes SPICE support for better graphics performance
# - CPU passthrough for better VM performance
# - qcow2 format for efficient disk usage
# - For troubleshooting:
#   - Check libvirtd service: systemctl status libvirtd
#   - Verify tool installation: which virt-viewer
#   - Check dconf settings: dconf dump /org/virt-manager/
# - To customize:
#   - Change graphics-type to 'vnc' if SPICE isn't working
#   - Adjust cpu-default based on host capabilities
#   - Add additional ISO storage locations
# ============================================================================
