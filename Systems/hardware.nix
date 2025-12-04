# /etc/nixos/SpidyNix/Systems/hardware.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # HARDWARE TYPE OPTIONS
  # ============================================================================
  # Options to enable/disable different hardware configurations
  # ============================================================================

  nixpkgs.config.cudaSupport = false;

  # ============================================================================
  # SECTION 1: CORE SYSTEM HARDWARE
  # ============================================================================

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
    enable32Bit = true; 

    extraPackages = with pkgs; [
      # Mesa Drivers (Core OpenGL/Vulkan implementation)
      libva-utils
      libva
      mesa-gl-headers
      intel-media-driver      # Modern VAAPI driver for Intel GPUs (Broadwell+)
      intel-compute-runtime   # OpenCL support for Intel GPUs
      vpl-gpu-rt             # Intel Video Processing Library
      intel-graphics-compiler
      
    ];

    # 32-bit versions of the same drivers for compatibility.
    extraPackages32 = with pkgs; [
      intel-media-driver
      libva
    ];
  };

  # ENVIRONMENT VARIABLES FOR VIDEO ACCELERATION
  environment.sessionVariables = { 
    LIBVA_DRIVER_NAME = "iHD"; 
  };

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
  # SECTION 5: MISCELLANEOUS
  # ============================================================================

  # HARDWARE CLOCK
  time.hardwareClockInLocalTime = lib.mkDefault false;
  chaotic.mesa-git.enable = true;
  chaotic.mesa-git.extraPackages = with pkgs; [
      mesa_git.opencl 
      intel-media-driver 
      intel-ocl
      mesa_git
      mesa32_git 
      intel-vaapi-driver
    ];
}