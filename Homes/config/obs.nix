{ config, pkgs, lib, ... }:

{
  # =========================================================================
  # OBS STUDIO CONFIGURATION
  # =========================================================================
  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      obs-gstreamer                    # GStreamer plugin
      obs-pipewire-audio-capture       # PipeWire audio capture
      obs-vaapi                        # VA-API plugin for encoding
    ];

    package = pkgs.symlinkJoin {
      name = "obs-studio";
      paths = [
        (pkgs.obs-studio.override {
          pipewireSupport = true;      # Enable PipeWire support
          browserSupport = true;       # Enable browser source support
        })
      ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/obs \
          --add-flags "--ozone-platform=wayland"
      '';
    };
  };
}
