# /etc/nixos/SpidyNix/Systems/power.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # TLP - ADVANCED POWER MANAGEMENT
  # ============================================================================
  # TLP provides intelligent power management with AC/battery profiles

  services.tlp = {
    enable = true;

    settings = {
      # CPU PERFORMANCE SETTINGS
      CPU_SCALING_GOVERNOR_ON_AC = "performance";    # Max performance when plugged in
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";     # Power saving on battery
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";  # EPP for Intel CPUs
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 1;                           # Enable turbo boost when plugged in
      CPU_BOOST_ON_BAT = 0;                          # Disable on battery for power savings

      # PLATFORM POWER PROFILES
      PLATFORM_PROFILE_ON_AC = "performance";        # Full performance on AC
      PLATFORM_PROFILE_ON_BAT = "low-power";         # Power saving on battery

      # DISK POWER MANAGEMENT
      DISK_IDLE_SECS_ON_AC = 0;                      # Never spin down on AC (performance)
      DISK_IDLE_SECS_ON_BAT = 2;                     # Spin down quickly on battery
      SATA_LINKPWR_ON_AC = "med_power_with_dipm";    # SATA power management on AC
      SATA_LINKPWR_ON_BAT = "min_power";             # Aggressive SATA power saving
      AHCI_RUNTIME_PM_ON_AC = "on";                  # NVMe runtime PM on AC
      AHCI_RUNTIME_PM_ON_BAT = "auto";               # Auto NVMe power management

      # PCIe ASYNC SUSPEND
      RUNTIME_PM_ON_AC = "on";                       # PCIe runtime suspend on AC
      RUNTIME_PM_ON_BAT = "auto";                    # Auto PCIe power management

      # USB DEVICE POWER MANAGEMENT
      USB_AUTOSUSPEND = 1;                           # Enable USB autosuspend
      USB_EXCLUDE_AUDIO = 1;                         # Keep audio devices awake
      USB_EXCLUDE_BTUSB = 1;                         # Keep Bluetooth awake
      USB_EXCLUDE_PHONE = 1;                         # Keep phone connections awake
      USB_EXCLUDE_PRINTER = 1;                       # Keep printers awake
      USB_EXCLUDE_WWAN = 1;                          # Keep mobile broadband awake

      # AUDIO POWER SAVING
      SOUND_POWER_SAVE_ON_AC = 0;                    # Disable audio power saving on AC
      SOUND_POWER_SAVE_ON_BAT = 1;                   # Enable on battery

      # WIFI POWER SAVING
      WIFI_PWR_ON_AC = "off";                        # Disable WiFi power saving on AC
      WIFI_PWR_ON_BAT = "on";                        # Enable WiFi power saving on battery
    };
  };

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
