# /etc/nixos/SpidyNix/Homes/apps/chromium-flag.nix
{ config, pkgs, lib, ... }:
{
  # Chromium flags configuration file
  xdg.configFile."chromium-flags.conf".text = ''
    # =========================================================================
    # WAYLAND SUPPORT
    # =========================================================================
    --ozone-platform=wayland  # Force Wayland platform
    # =========================================================================
    # GPU AND VIDEO ACCELERATION
    # =========================================================================
    --use-gl=desktop  # Use desktop OpenGL
    --ignore-gpu-blocklist  # Ignore GPU blocklist
    --enable-gpu-rasterization  # Enable GPU rasterization
    --enable-zero-copy  # Enable zero-copy GPU
    --enable-vulkan  # Enable Vulkan
    --disable-gpu-driver-bug-workarounds  # Disable GPU driver bug workarounds
    --disable-features=UseChromeOSDirectVideoDecoder  # Disable ChromeOS video decoder
    --enable-features=UseOzonePlatform,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,VaapiIgnoreDriverChecks,OverlayScrollbar,ParallelDownloading  # Enable various features
    # =========================================================================
    # HARDWARE ACCELERATION
    # =========================================================================
    --enable-hardware-overlays  # Enable hardware overlays
    --enable-accelerated-video-decode  # Enable accelerated video decode
    --enable-accelerated-video-encode  # Enable accelerated video encode
    --enable-accelerated-mjpeg-decode  # Enable accelerated MJPEG decode
    --enable-oop-rasterization  # Enable out-of-process rasterization
    --enable-raw-draw  # Enable raw draw
    --enable-webgl-developer-extensions  # Enable WebGL developer extensions
    --enable-accelerated-2d-canvas  # Enable accelerated 2D canvas
    --enable-direct-composition  # Enable direct composition
    --enable-drdc  # Enable DRDC
    --enable-gpu-compositing  # Enable GPU compositing
    # =========================================================================
    # PERFORMANCE
    # =========================================================================
    --enable-media-router  # Enable media router
    --enable-smooth-scrolling  # Enable smooth scrolling
    # =========================================================================
    # PRIVACY FEATURES
    # =========================================================================
    --disable-search-engine-collection  # Disable search engine collection
    --extension-mime-request-handling=always-prompt-for-install  # Always prompt for extension install
    --fingerprinting-canvas-image-data-noise  # Add noise to canvas image data
    --fingerprinting-canvas-measuretext-noise  # Add noise to canvas measure text
    --fingerprinting-client-rects-noise  # Add noise to client rects
    --popups-to-tabs  # Open popups in tabs
    --force-punycode-hostnames  # Force punycode hostnames
    --show-avatar-button=incognito-and-guest  # Show avatar button in incognito and guest
    # =========================================================================
    # MISCELLANEOUS
    # =========================================================================
    --no-default-browser-check  # Disable default browser check
    --no-pings  # Disable pings
  '';

  # ============================================================================
  # SESSION VARIABLES
  # ============================================================================
  # Environment variables for hardware video acceleration
  # ============================================================================
  home.sessionVariables = {
    # Intel GPU driver (use "iHD" for modern Intel, "i965" for legacy)
    LIBVA_DRIVER_NAME = "iHD";
    LIBVA_MESSAGING_LEVEL = "1";  # Set VA-API messaging level
    LIBGL_ALWAYS_SOFTWARE = "0";  # Disable software rendering
    # Force hardware video acceleration
    ENABLE_VAAPI = "1";  # Enable VA-API
    ENABLE_VDPAU = "1";  # Enable VDPAU
    # VA-API hardware video encoding
    VAAPI_DISABLE_ENCODER_CHECKING = "1";  # Disable encoder checking
    # Wayland EGL platform
    EGL_PLATFORM = "wayland";  # Set EGL platform to Wayland
  };
}
# ============================================================================
#  CHROMIUM FLAGS
# Flags for Chromium-based browsers
# Applied to: Chromium, Microsoft Edge, Brave, etc.
# ============================================================================
# ============================================================================
# CHROMIUM FLAGS CONFIGURATION
# ============================================================================
# This file configures Chromium-based browsers (Chromium, Edge, etc.)
# with optimized flags for performance and hardware acceleration
# ============================================================================
# ============================================================================
# NOTES
# ============================================================================
# CHROMIUM FLAGS:
# - Apply to all Chromium-based browsers
# - Place in ~/.config/chromium-flags.conf
# - Browsers read this file on startup
#
# HARDWARE ACCELERATION:
# - Intel GPU: Use iHD driver (Broadwell and newer)
# - Legacy Intel: Use i965 driver (older than Broadwell)
# - AMD GPU: Use radeonsi driver
# - NVIDIA: Use nvidia driver
#
# CHECKING ACCELERATION:
# - Open chrome://gpu in browser
# - Check "Video Acceleration Information"
# - Should show "Hardware accelerated" for decode/encode
#
# VAAPI:
# - Check available drivers: vainfo
# - Should show iHD or i965 for Intel
# - Verify with: mpv --hwdec=auto video.mp4
#
# TROUBLESHOOTING:
# - No acceleration: Check LIBVA_DRIVER_NAME matches your GPU
# - Black screen: Try removing --disable-gpu-driver-bug-workarounds
# - Crashes: Remove --enable-features flags one by one
# - Check logs: chromium --enable-logging --v=1
#
# DRIVER SELECTION:
# - Intel (modern): LIBVA_DRIVER_NAME = "iHD"
# - Intel (legacy): LIBVA_DRIVER_NAME = "i965"
# - AMD: LIBVA_DRIVER_NAME = "radeonsi"
# - NVIDIA: LIBVA_DRIVER_NAME = "nvidia" (with nvidia-vaapi-driver)
# ============================================================================
