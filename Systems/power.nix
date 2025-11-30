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
  #services.scx = {
  #  enable = true;
    # Force use of scx_lavd scheduler
   # scheduler = lib.mkForce "scx_lavd";  # Options: scx_rusty, scx_lavd, scx_bpfland
 # };

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
# ============================================================================
# POWER MANAGEMENT CONFIGURATION
# ============================================================================
# This file configures power management and performance settings including:
#   - TLP (power management daemon)
#   - Zram (compressed swap in RAM)
#   - CPU frequency scaling
#   - Suspend/hibernate settings
#   - Power profiles
#   - Battery optimization (for laptops)
# ============================================================================
# NOTES
# ============================================================================
# POWER MANAGEMENT TOOLS:
# - TLP: Automatic power management (recommended for laptops)
# - auto-cpufreq: Alternative to TLP (don't use both!)
# - powertop: Monitor and tune power consumption
# - thermald: Prevents overheating (Intel only)
#
# TLP VS AUTO-CPUFREQ:
# - TLP: More features, better for laptops, stable
# - auto-cpufreq: Simpler, automatic profile switching
# - Choose one, not both (they conflict)
# - This config uses TLP
#
# ZRAM:
# - Compressed swap in RAM
# - Faster than disk swap
# - Reduces disk writes (longer SSD life)
# - Uses 50% of RAM by default
# - Priority 100 (higher than disk swap)
#
# CPU GOVERNORS:
# - performance: Maximum performance, higher power usage
# - powersave: Better battery life, lower performance
# - ondemand: Dynamic scaling based on load
# - schedutil: Kernel scheduler-based scaling (modern default)
#
# POWER PROFILES:
# - AC: Performance mode when plugged in
# - Battery: Power saving mode on battery
# - TLP automatically switches between profiles
#
# MONITORING POWER:
# - powertop: sudo powertop
# - TLP status: sudo tlp-stat
# - Battery: tlp-stat -b
# - CPU: watch -n 1 cat /proc/cpuinfo | grep MHz
#
# BATTERY THRESHOLDS:
# - Extends battery life by limiting charge
# - Only works on ThinkPads and some other laptops
# - Example: Charge to 80%, start charging at 75%
# - Uncomment and adjust START_CHARGE_THRESH and STOP_CHARGE_THRESH
#
# SUSPEND VS HIBERNATE:
# - Suspend: Low power mode, RAM stays powered
# - Hibernate: Save to disk, power off completely
# - Hybrid: Suspend, but save state to disk too
# - This config: Suspend enabled, hibernate disabled
#
# SCX SCHEDULERS:
# - scx_rusty: Balanced performance and latency
# - scx_lavd: Low-latency optimized
# - scx_bpfland: Multi-core optimization
# - Requires Linux 6.6+ with sched-ext support
#
# SSD OPTIMIZATION:
# - TRIM: Maintains SSD performance over time
# - fstrim runs weekly (configured in service.nix)
# - NoCoW: Disabled for /nix (configured in boot.nix)
#
# DISK POWER SAVING:
# - Spin down disks when idle
# - AC: Never spin down (performance)
# - Battery: Spin down after 2 seconds (power saving)
#
# USB POWER SAVING:
# - Autosuspend enabled for most USB devices
# - Excluded: Audio, Bluetooth, Phone, Printer, WWAN
# - Prevents issues with critical USB devices
#
# WIFI POWER SAVING:
# - AC: Disabled (better performance)
# - Battery: Enabled (better battery life)
# - May cause connection issues if enabled on AC
#
# AUDIO POWER SAVING:
# - AC: Disabled (no audio glitches)
# - Battery: Enabled (save power)
# - Power saving timeout: 10 seconds
#
# PCIE POWER MANAGEMENT:
# - AC: Enabled (minimal impact)
# - Battery: Auto (aggressive power saving)
# - ASPM: Active State Power Management
#
# TROUBLESHOOTING:
# - Suspend issues: Check journalctl -u systemd-suspend
# - Performance issues: Try performance governor
# - Battery draining: Check sudo tlp-stat
# - USB devices disconnecting: Add to USB_EXCLUDE list
# - WiFi dropping: Disable WiFi power saving
#
# LAPTOP-SPECIFIC:
# - Battery thresholds (ThinkPad)
# - Keyboard backlight timeout
# - Screen brightness on battery
# - All handled by TLP automatically
#
# DESKTOP OPTIMIZATION:
# - Use performance governor
# - Disable most power saving features
# - Keep CPU boost enabled
# - Focus on performance over power
#
# GAMING OPTIMIZATION:
# - Use performance governor
# - Disable CPU frequency scaling
# - Keep system plugged in (laptops)
# - GameMode handles some of this automatically
#
# CHECKING CURRENT STATE:
# - CPU frequency: cat /proc/cpuinfo | grep MHz
# - Governor: cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# - Power profile: cat /sys/firmware/acpi/platform_profile
# - Zram status: zramctl
#
# MANUAL CONTROL:
# - Change governor: echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
# - TLP battery mode: sudo tlp bat
# - TLP AC mode: sudo tlp ac
# - Start TLP: sudo tlp start
#
# POWER CONSUMPTION:
# - Check: sudo powertop
# - Optimize: sudo powertop --auto-tune (careful, may cause issues)
# - TLP handles most optimizations automatically
#
# ZRAM DETAILS:
# - Check usage: zramctl
# - Check stats: cat /sys/block/zram0/mm_stat
# - Compression ratio: Usually 2:1 to 4:1
# - Performance: Much faster than disk swap
# ============================================================================
