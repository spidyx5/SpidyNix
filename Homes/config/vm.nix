{ config, pkgs, lib, inputs, ... }:

{
  # =========================================================================
  # VIRT-MANAGER DCONF SETTINGS (UI & Preferences)
  # =========================================================================
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/virt-manager/virt-manager" = {
      xmleditor-enabled = true;
      stats-update-interval = 1;
      console-accels = true;
    };

    "org/virt-manager/virt-manager/console" = {
      resize-guest = 1;
      scaling = 1;
    };

    "org/virt-manager/virt-manager/new-vm" = {
      graphics-type = "spice";
      cpu-default = "host-passthrough";
      storage-format = "qcow2";
    };

    "org/virt-manager/virt-manager/urls" = {
      isos = [ "/var/lib/libvirt/isos" ];
    };
  };

  # =========================================================================
  # =========================================================================
  # VM XML snippets for hiding hypervisor presence
  # Add these to your VM XML in virt-manager for better compatibility
  home.file.".config/virt-manager/notes.txt".text = ''
    # QEMU  Tips for virt-manager:
    
    1. Hide KVM/Hypervisor:
       <features>
         <kvm>
           <hidden state="on"/>
         </kvm>
       </features>
    
    2. CPU Passthrough (for gaming):
       <cpu mode="host-passthrough">
         <feature policy="require" name="topoext"/>
       </cpu>
    
    3. Disable SMEP/SMAP (if needed for older OSes):
       <cpu mode="host-passthrough">
         <feature policy="disable" name="smep"/>
         <feature policy="disable" name="smap"/>
       </cpu>
    
    4. Enable Nested Virtualization:
       <cpu mode="host-passthrough">
         <feature policy="require" name="vmx"/>
       </cpu>
    
    5. Machine Type (for better compatibility):
       <os>
         <type arch="x86_64" machine="pc">hvm</type>
       </os>
  '';
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
