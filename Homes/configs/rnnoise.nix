# /etc/nixos/SpidyNix/Homes/configs/rnnoise.nix
{pkgs, ...}: let
  json = pkgs.formats.json {};  # JSON format

  # PipeWire RNNoise configuration
  pw_rnnoise_config = {
    "context.modules" = [
      {
        "name" = "libpipewire-module-filter-chain";  # Filter chain module
        "args" = {
          "node.description" = "Noise Canceling source";  # Node description
          "media.name" = "Noise Canceling source";  # Media name
          "filter.graph" = {
            "nodes" = [
              {
                "type" = "ladspa";  # LADSPA plugin
                "name" = "rnnoise";  # Plugin name
                "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";  # Plugin path
                "label" = "noise_suppressor_stereo";  # Plugin label
                "control" = {"VAD Threshold (%)" = 70.0;};  # Control
              }
            ];
          };
          "audio.position" = ["FL" "FR"];  # Audio position
          "capture.props" = {
            "node.name" = "effect_input.rnnoise";  # Capture node name
            "node.passive" = true;  # Capture node passive
          };
          "playback.props" = {
            "node.name" = "effect_output.rnnoise";  # Playback node name
            "media.class" = "Audio/Source";  # Playback media class
          };
        };
      }
    ];
  };
in {
  # PipeWire configuration file
  xdg.configFile."pipewire/pipewire.conf.d/99-input-denoising.conf" = {
    source = json.generate "99-input-denoising.conf" pw_rnnoise_config;  # Generate JSON configuration
  };
}
# Notes
#
