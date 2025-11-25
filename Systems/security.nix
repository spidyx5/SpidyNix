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
# ============================================================================
# SECURITY CONFIGURATION
# ============================================================================
# This file configures security hardening and protection systems including:
#   - AppArmor (mandatory access control)
#   - Polkit (privilege escalation)
#   - TPM2 (hardware security)
#   - Kernel hardening
#   - PAM configuration
#   - Security policies
# ============================================================================
# ADDITIONAL SECURITY PACKAGES
# ============================================================================
# Security tools and utilities
# ============================================================================
# FIREWALL
# ============================================================================
# Firewall is configured in network.nix
# ============================================================================

# networking.firewall.enable = true;

# ============================================================================
# NOTES
# ============================================================================
# SECURITY LEVELS:
# - Basic: Firewall, AppArmor, regular updates
# - Moderate: Above + TPM2, kernel hardening
# - Paranoid: Above + hideProcessInformation, disable SMT, audit daemon
#
# APPARMOR:
# - Mandatory Access Control (MAC) system
# - Restricts programs based on profiles
# - Complain mode: Log violations but don't block
# - Enforce mode: Block violations
# - Check status: sudo aa-status
# - Profile location: /etc/apparmor.d/
#
# POLKIT:
# - Manages privilege escalation
# - GUI applications requesting root access
# - Rules in extraConfig apply to all users
# - Check auth: pkaction --verbose
#
# TPM2:
# - Hardware security module
# - Stores encryption keys securely
# - Used for: disk encryption, secure boot, attestation
# - Check: tpm2_pcrread
# - Only works if TPM2 chip is present
#
# KERNEL HARDENING:
# - forcePageTableIsolation: Meltdown mitigation
# - protectKernelImage: Prevent kernel modification
# - hideProcessInformation: Hide other users' processes
# - allowUserNamespaces: Needed for containers, sandboxing
#
# PAM (Pluggable Authentication Modules):
# - Handles authentication
# - Password policies
# - Login limits
# - Session management
# - Configuration: /etc/pam.d/
#
# REALTIME KIT:
# - Allows low-latency audio
# - Needed for PipeWire, JACK
# - Grants temporary realtime priority
# - Safe to enable
#
# GNOME KEYRING:
# - Stores passwords, SSH keys, GPG keys
# - Automatically unlocked on login
# - GUI: seahorse
# - CLI: secret-tool
#
# SECURITY AUDIT:
# - Run: sudo lynis audit system
# - Reviews security configuration
# - Provides recommendations
# - Check regularly for improvements
#
# ROOTKIT DETECTION:
# - Run: sudo chkrootkit
# - Scans for rootkits and backdoors
# - False positives possible
# - Run regularly for monitoring
#
# PASSWORD MANAGEMENT:
# - KeePassXC: Local password database
# - Encrypted with master password
# - Browser integration available
# - Sync via cloud (encrypted)
#
# ENCRYPTION:
# - GPG: File and email encryption
# - Age: Modern alternative to GPG
# - Disk encryption: LUKS (configured in hardware-configuration.nix)
#
# APPARMOR COMMANDS:
# - Status: sudo aa-status
# - Enable profile: sudo aa-enforce /etc/apparmor.d/profile
# - Complain mode: sudo aa-complain /etc/apparmor.d/profile
# - Reload profiles: sudo systemctl reload apparmor
#
# POLKIT COMMANDS:
# - List actions: pkaction
# - Check authorization: pkcheck --action-id ACTION
# - Monitor: pkmon
#
# TPM2 COMMANDS:
# - Read PCRs: tpm2_pcrread
# - Test: tpm2_getrandom 8
# - Clear: tpm2_clear (DANGER!)
#
# SECURITY BEST PRACTICES:
# 1. Keep system updated: nix flake update && nh os switch
# 2. Use strong passwords
# 3. Enable full disk encryption
# 4. Regular backups
# 5. Monitor logs: journalctl -p err
# 6. Review security audit: sudo lynis audit system
# 7. Minimal installed software
# 8. Firewall properly configured
# 9. SSH keys instead of passwords
# 10. Regular security scans
#
# TROUBLESHOOTING:
# - AppArmor blocking: Check journalctl | grep apparmor
# - Polkit denying: Check pkmon for authorization requests
# - TPM not working: Verify in BIOS/UEFI
# - Permission denied: Check user groups and polkit rules
#
# ADVANCED SECURITY:
# - Enable audit daemon for comprehensive logging
# - Use SELinux instead of AppArmor (more complex)
# - Implement OSSEC or AIDE for intrusion detection
# - Network segmentation with VLANs
# - Full disk encryption with TPM2
#
# COMPROMISE RECOVERY:
# 1. Disconnect from network
# 2. Boot from live USB
# 3. Scan for rootkits
# 4. Review logs
# 5. Change all passwords
# 6. Reinstall if necessary
# 7. Restore from clean backup
# 8. Review security configuration
#
# COMPLIANCE:
# - This configuration provides reasonable security
# - For compliance (SOC2, ISO27001): Additional hardening needed
# - Consult security professionals for critical systems
# - Regular penetration testing recommended
#
# PERFORMANCE VS SECURITY:
# - Some security features impact performance
# - forcePageTableIsolation: ~5% performance hit
# - AppArmor: Minimal impact
# - Audit daemon: Can impact I/O performance
# - Balance based on threat model
# ============================================================================
