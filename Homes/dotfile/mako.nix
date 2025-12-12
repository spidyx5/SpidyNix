{ config, pkgs, lib, inputs, ... }:

{
  # =========================================================================
  # MAKO NOTIFICATION DAEMON
  # =========================================================================
  services.mako = {
    enable = true;

    settings = {
      # ===================================================================
      # APPEARANCE
      # ===================================================================
      font = "ZedMono Nerd Font 10";
      backgroundColor = "#1a1b26";      # TokyoNight background
      borderColor = "#7aa2f7";          # TokyoNight blue
      textColor = "#c0caf5";            # TokyoNight foreground
      borderRadius = 8;
      borderSize = 2;

      # ===================================================================
      # BEHAVIOR
      # ===================================================================
      defaultTimeout = 5000;             # 5 seconds
      layer = "overlay";
      anchor = "top-right";

      # ===================================================================
      # GROUPING
      # ===================================================================
      max-visible = 5;
      sort = "-time";
    };
  };
}
