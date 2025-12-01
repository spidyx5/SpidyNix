# /etc/nixos/SpidyNix/Systems/security.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # POLKIT - PRIVILEGE ESCALATION
  # ============================================================================
  # Polkit manages privilege escalation for GUI applications
  # Custom rules allow wheel group convenience without passwords

  security.polkit = {
    enable = true;

    extraConfig = ''
      /* Allow wheel group to manage systemd units without password */
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });

      /* Allow wheel group to mount drives without password */
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.udisks2.filesystem-mount-system" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };

  # ============================================================================
  # APPARMOR - MANDATORY ACCESS CONTROL
  # ============================================================================
  # Enable AppArmor for mandatory access control
  security.apparmor = {
    enable = true;
    # Kill processes that should be confined but aren't
    killUnconfinedConfinables = true;
    # Include standard AppArmor profiles
    packages = [ pkgs.apparmor-profiles ];
  };

  # ============================================================================
  # TPM2 - HARDWARE SECURITY
  # ============================================================================
  # Enable TPM2 for hardware security
  security.tpm2 = {
    enable = true;
    # Expose TPM chip as a smartcard
    pkcs11.enable = true;
    # Enable TPM2 TCTI environment
    tctiEnvironment.enable = true;
  };

  # ============================================================================
  # KERNEL HARDENING
  # ============================================================================
  security = {
    # Protect kernel image from modification (good security, low impact)
    protectKernelImage = false;

    # Allow user namespaces (Required for Steam, Flatpak, Chrome sandboxing)
    allowUserNamespaces = true;
    # Allow simultaneous multithreading
    allowSimultaneousMultithreading = true;
    # Performance Note: We do NOT enable forcePageTableIsolation here.
    # We let the CachyOS kernel handle mitigations via boot parameters.
  };

  # ============================================================================
  # PAM CONFIGURATION
  # ============================================================================
  security.pam = {
    # Login Limits (Open Files) - Critical for gaming/Wine
    loginLimits = [
      { domain = "*"; type = "soft"; item = "nofile"; value = "524288"; }
      { domain = "*"; type = "hard"; item = "nofile"; value = "1048576"; }
    ];
  };

  # ============================================================================
  # DBUS - HIGH PERFORMANCE BROKER
  # ============================================================================
  # Enable D-Bus with broker implementation
  services.dbus = {
    enable = true;
    # Use 'broker' which is a faster/modern replacement for 'daemon'
    implementation = "broker";
    # Include dconf package
    packages = [ pkgs.dconf ];
  };
}
