# /etc/nixos/SpidyNix/Systems/power.nix
{ config, pkgs, lib, ... }:
{

  # Enable power management
  powerManagement = {
    enable = true;

    # Enable powertop for power consumption monitoring
    powertop.enable = true;
  };

  # ============================================================================
  # ZRAM - COMPRESSED SWAP
  # ============================================================================
  # Zram creates a compressed block device in RAM for swap
  # Provides faster swap and reduces disk writes
  # ============================================================================

  zramSwap = {
    enable = true;

    # Use 50% of RAM for zram
    memoryPercent = 50;

    # Use zstd compression algorithm
    algorithm = "zstd";

    # Set zram priority to 100 (higher than disk swap)
    priority = 100;
  };

  # ============================================================================
  # SYSTEMD SLEEP CONFIGURATION
  # ============================================================================
  # Configure suspend, hibernate, and hybrid sleep
  # ============================================================================

  systemd.sleep.extraConfig = ''
    # Allow suspend
    AllowSuspend=yes
    # Disable hibernation
    AllowHibernation=yes
    # Disable suspend-then-hibernate
    AllowSuspendThenHibernate=no
    # Disable hybrid sleep
    AllowHybridSleep=yes
  '';

  # Enable SCX scheduler
  services.scx = {
    enable = true;
    # Force use of scx_lavd scheduler
    scheduler = lib.mkForce "scx_lavd";  # Options: scx_rusty, scx_lavd, scx_bpfland
  };

  # Enable thermald for thermal management (Intel processors)
  services.thermald.enable = true;

  # ============================================================================
  # LOGIND CONFIGURATION
  # ============================================================================
  # Login manager configuration for power management
  # ============================================================================

  services.logind.settings = {
    Login = {
      HandlePowerKey = "suspend";  # Suspend on power button press
     #powerKey = "suspend";       # Suspend on power button press
      HandleSuspendKey = "suspend";  # Suspend on suspend key press
      HandleHibernateKey = "yes";  #  hibernate key
      HandleLidSwitch = "suspend";   # Suspend on lid close
      HandleLidSwitchDocked = "ignore";  # Ignore lid switch when docked
      IdleAction = "ignore";           # Ignore idle action
      IdleActionSec = "30min";         # Set idle timeout to 30 minutes
    };
  };
}
# ZRAM DETAILS:
# - Check usage: zramctl
# - Check stats: cat /sys/block/zram0/mm_stat
# - Compression ratio: Usually 2:1 to 4:1
# - Performance: Much faster than disk swap
# ============================================================================
