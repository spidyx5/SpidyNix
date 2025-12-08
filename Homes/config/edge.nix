{ config, pkgs, lib, ... }:

{
  # =========================================================================
  # MICROSOFT EDGE CONFIGURATION
  # =========================================================================
  home.packages = with pkgs; [
    (microsoft-edge.override {
      commandLineArgs = [
        # ===================================================================
        # GPU ACCELERATION
        # ===================================================================
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"

        # ===================================================================
        # WAYLAND SUPPORT
        # ===================================================================
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"

        # ===================================================================
        # MEMORY OPTIMIZATION
        # ===================================================================
        "--process-per-site"

        # ===================================================================
        # FEATURES
        # ===================================================================
        "--enable-features=WebUIDarkMode,UseOzonePlatform,VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,WebRTCPipeWireCapturer,WaylandWindowDecorations"
      ];
    })
  ];
}
