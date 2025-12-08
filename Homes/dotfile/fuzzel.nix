{ config, pkgs, lib, ... }:

{
  # =========================================================================
  # FUZZEL - APPLICATION LAUNCHER
  # =========================================================================
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        terminal = "${pkgs.ghostty}/bin/ghostty";
        layer = "overlay";
        width = 60;
        font = "ZedMono Nerd Font:size=14";
        icon-theme = "Papirus-Dark";
      };

      colors = {
        # TokyoNight color scheme
        background = "1a1b26dd";      # TokyoNight BG transparent
        text = "c0caf5ff";            # TokyoNight FG
        match = "f7768eff";           # Red match
        selection = "7aa2f7ff";       # Blue selection
        selection-text = "1a1b26ff";  # Selection text color
        border = "7aa2f7ff";          # Border color
      };

      border = {
        width = 2;
        radius = 10;
      };
    };
  };
}
