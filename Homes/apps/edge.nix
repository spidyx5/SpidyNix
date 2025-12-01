# /etc/nixos/SpidyNix/Homes/apps/edge.nix
{pkgs, ...}:
{
  # Microsoft Edge configuration
    home.packages = with pkgs; [
      (microsoft-edge.override {
        commandLineArgs = [
          # Force GPU acceleration
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
          # "--enable-unsafe-webgpu"
  
          # Force to run on Wayland
          "--ozone-platform-hint=auto"
          "--ozone-platform=wayland"
          "--enable-wayland-ime"
  
          # Reduce memory usage
          "--process-per-site"
  
          # Force dark mode
          # "--force-dark-mode"
  
          # Enable additional features
          "--enable-features=WebUIDarkMode,UseOzonePlatform,VaapiVideoDecodeLinuxGL,VaapiVideoDecoder,WebRTCPipeWireCapturer,WaylandWindowDecorations"
        ];
      })
    ];
}
# Reference:
# https://wiki.archlinux.org/title/chromium
# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
# For fcitx5, we also need to disable "fractional scale under Wayland" to force it to run on Wayland natively.
