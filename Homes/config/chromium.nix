{ config, pkgs, lib, inputs, ... }:

{
  # =========================================================================
  # CHROMIUM FLAGS CONFIGURATION
  # =========================================================================
  xdg.configFile."chromium-flags.conf".text = ''
    # =========================================================================
    # WAYLAND SUPPORT
    # =========================================================================
    --ozone-platform=wayland

    # =========================================================================
    # GPU AND VIDEO ACCELERATION
    # =========================================================================
    --use-gl=desktop
    --ignore-gpu-blocklist
    --enable-gpu-rasterization
    --enable-zero-copy
    --enable-vulkan
    --disable-gpu-driver-bug-workarounds
    --disable-features=UseChromeOSDirectVideoDecoder
    --enable-features=UseOzonePlatform,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,VaapiIgnoreDriverChecks,OverlayScrollbar,ParallelDownloading

    # =========================================================================
    # HARDWARE ACCELERATION
    # =========================================================================
    --enable-hardware-overlays
    --enable-accelerated-video-decode
    --enable-accelerated-video-encode
    --enable-accelerated-mjpeg-decode
    --enable-oop-rasterization
    --enable-raw-draw
    --enable-webgl-developer-extensions
    --enable-accelerated-2d-canvas
    --enable-direct-composition
    --enable-drdc
    --enable-gpu-compositing

    # =========================================================================
    # PERFORMANCE
    # =========================================================================
    --enable-media-router
    --enable-smooth-scrolling

    # =========================================================================
    # PRIVACY FEATURES
    # =========================================================================
    --disable-search-engine-collection
    --extension-mime-request-handling=always-prompt-for-install
    --fingerprinting-canvas-image-data-noise
    --fingerprinting-canvas-measuretext-noise
    --fingerprinting-client-rects-noise
    --popups-to-tabs
    --force-punycode-hostnames
    --show-avatar-button=incognito-and-guest

    # =========================================================================
    # MISCELLANEOUS
    # =========================================================================
    --no-default-browser-check
    --no-pings
  '';

  # =========================================================================
  # SESSION VARIABLES - HARDWARE VIDEO ACCELERATION
  # =========================================================================
  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    LIBVA_MESSAGING_LEVEL = "1";
    LIBGL_ALWAYS_SOFTWARE = "0";
    ENABLE_VAAPI = "1";
    ENABLE_VDPAU = "1";
    VAAPI_DISABLE_ENCODER_CHECKING = "1";
    EGL_PLATFORM = "wayland";
  };
}
