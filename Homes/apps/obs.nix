# /etc/nixos/SpidyNix/Homes/apps/obs.nix
{pkgs, ...}: {
  programs = {
    obs-studio = {
      enable = true;  # Enable OBS Studio
      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer  # GStreamer plugin
        obs-pipewire-audio-capture  # PipeWire audio capture plugin
        obs-vaapi  # VA-API plugin
      ];
      package = pkgs.symlinkJoin {
        name = "obs-studio";  # Package name
        paths = [
          (pkgs.obs-studio.override {
            pipewireSupport = true;  # Enable PipeWire support
            browserSupport = true;  # Enable browser support
          })
        ];
        buildInputs = [pkgs.makeWrapper];  # Build inputs
        postBuild = ''
          wrapProgram $out/bin/obs \
            --add-flags "--ozone-platform=wayland"  # Add Wayland flag
        '';
      };
    };
  };

  # ============================================================================
  # OBS STUDIO PLUGINS PACKAGES
  # ============================================================================
  # OBS Studio plugins as home packages
  home.packages = with pkgs; [
    obs-studio-plugins.obs-vkcapture  # OBS VKCapture plugin as home package
  ];
}
