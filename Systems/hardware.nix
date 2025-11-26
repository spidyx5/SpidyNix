# /etc/nixos/SpidyNix/Systems/hardware.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # HARDWARE TYPE OPTIONS
  # ============================================================================
  # Options to enable/disable different hardware configurations
  # ============================================================================
  options.hardwareType = {
    intel = lib.mkEnableOption "Intel hardware configuration";
    amd = lib.mkEnableOption "AMD hardware configuration";
    nvidia = lib.mkEnableOption "NVIDIA hardware configuration";
    vm = lib.mkEnableOption "VM hardware configuration";
  };

  config = {
    # Default hardware type (Intel)
    hardwareType = {
      intel = lib.mkDefault true;
      amd = lib.mkDefault false;
      nvidia = lib.mkDefault false;
      vm = lib.mkDefault false;
    };

  # ============================================================================
  # SECTION 1: CORE SYSTEM HARDWARE
  # ============================================================================

  # CPU MICROCODE - Apply CPU updates for security and stability
  hardware.cpu.intel.updateMicrocode = lib.mkIf config.hardwareType.intel true;
  hardware.cpu.amd.updateMicrocode = lib.mkIf config.hardwareType.amd true;

  # FIRMWARE - Device firmware including redistributable firmware
  hardware.enableRedistributableFirmware = true;
  # Optional: Include non-free firmware (requires allowUnfree)
  # hardware.enableAllFirmware = true;

  # I2C DEVICES - Enable I2C support for sensors and peripherals
  hardware.i2c.enable = true;

  # ============================================================================
  # SECTION 2: GRAPHICS & DISPLAY
  # ============================================================================

  # MODERN GRAPHICS DRIVERS (Mesa, OpenGL, Vulkan)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Crucial for 32-bit games (Steam, Wine/Proton)

    # All necessary driver and acceleration packages.
    extraPackages = with pkgs; [
      # Mesa Drivers (Core OpenGL/Vulkan implementation)
      mesa
      libva-utils
      libva

      # Intel GPU Drivers & Acceleration
    ] ++ lib.optionals config.hardwareType.intel [
      intel-media-driver      # Modern VAAPI driver for Intel GPUs (Broadwell+)
      intel-compute-runtime   # OpenCL support for Intel GPUs
      vpl-gpu-rt             # Intel Video Processing Library
    ] ++ lib.optionals config.hardwareType.amd [
      # AMD GPU Drivers & Acceleration
      amdvlk                 # AMD Vulkan driver
      rocm-opencl-icd        # AMD OpenCL
      mesa-vdpau             # VDPAU support for AMD GPUs
    ] ++ lib.optionals config.hardwareType.nvidia [
      # NVIDIA GPU Drivers (if needed, but usually handled by services.xserver.videoDrivers)
    ];

    # 32-bit versions of the same drivers for compatibility.
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
    ] ++ lib.optionals config.hardwareType.intel [
      intel-media-driver
      libva
    ] ++ lib.optionals config.hardwareType.amd [
      # AMD 32-bit drivers if available
    ];
  };

  # NVIDIA DRIVERS (if enabled)
  services.xserver.videoDrivers = lib.mkIf config.hardwareType.nvidia [ "nvidia" ];
  hardware.nvidia = lib.mkIf config.hardwareType.nvidia {
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ENVIRONMENT VARIABLES FOR VIDEO ACCELERATION
  environment.sessionVariables = lib.mkMerge [
    (lib.mkIf config.hardwareType.intel {
      LIBVA_DRIVER_NAME = "iHD";
    })
    (lib.mkIf config.hardwareType.amd {
      LIBVA_DRIVER_NAME = "radeonsi";
    })
  ];

  # DEPRECATED OPENGL OPTION (For Reference)
  # The `hardware.opengl` options are now handled by `hardware.graphics`.
  hardware.opentabletdriver = {
    enable = true;  # Enable if you have a graphics tablet
    daemon.enable = true;
  };

  # ============================================================================
  # SECTION 3: PERIPHERALS & INPUT DEVICES
  # ============================================================================


  # CONTROLLER SUPPORT
  hardware.steam-hardware.enable = true; # Udev rules for Steam Controller/Deck
  hardware.xpadneo.enable = true;        # Advanced driver for wireless Xbox controllers

  # BRIGHTNESS CONTROL
  hardware.brillo.enable = true;

  # ============================================================================
  # SECTION 4: OPTIONAL HARDWARE (Disabled by Default)
  # ============================================================================

  # LOGITECH WIRELESS
  hardware.logitech.wireless = {
    enable = false;
    enableGraphical = false;
  };

  # QMK KEYBOARDS
  hardware.keyboard.qmk.enable = false;

  # ============================================================================
  # SECTION 5: MISCELLANEOUS
  # ============================================================================

  # HARDWARE CLOCK
  time.hardwareClockInLocalTime = lib.mkDefault false;
  };
}
# HARDWARE CONFIGURATION
# ============================================================================
# This file configures hardware support including:
#   - GPU drivers and acceleration (Intel)
#   - Bluetooth hardware
#   - Firmware updates
#   - Hardware acceleration
#   - Controller support
#   - CPU microcode
#   - Brightness control
# ============================================================================
# INTEL GPU DRIVERS:
# - intel-media-driver (iHD): For Broadwell (2014) and newer
# - intel-vaapi-driver (i965): For older Intel GPUs
# - Both included for maximum compatibility
# - System will automatically use the correct driver
#
# CHECKING YOUR GPU:
# - GPU info: lspci | grep VGA
# - Driver in use: glxinfo | grep "OpenGL renderer"
# - VAAPI support: vainfo
# - Vulkan support: vulkaninfo
#
# VAAPI (VIDEO ACCELERATION):
# - Hardware-accelerated video decoding/encoding
# - Reduces CPU usage during video playback
# - Check support: vainfo
# - Should show "iHD" or "i965" driver
#
# DRIVER SELECTION:
# - Broadwell and newer: Use iHD (intel-media-driver)
# - Older than Broadwell: Use i965 (intel-vaapi-driver)
# - Set via LIBVA_DRIVER_NAME environment variable
# - Test both to see which works better for your GPU
#
# 32-BIT SUPPORT:
# - Required for Steam games
# - Required for Wine/Proton
# - enable32Bit = true enables this
# - Both 64-bit and 32-bit drivers installed
#
# OPENGL:
# - Provided by Mesa
# - Check version: glxinfo | grep "OpenGL version"
# - Test: glxgears
# - Should show smooth 60+ FPS
#
# VULKAN:
# - Modern graphics API
# - Better performance than OpenGL in many cases
# - Check support: vulkaninfo
# - Used by modern games
