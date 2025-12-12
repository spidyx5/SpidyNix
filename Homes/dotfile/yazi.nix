{ config, pkgs, lib, inputs, ... }:

{
  # =========================================================================
  # YAZI FILE MANAGER CONFIGURATION
  # =========================================================================
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        image_filter = "lanczos3";
        image_quality = 90;
        sixel_fraction = 15;
      };
    };

    theme = {
      manager = {
        cwd = { fg = "#7aa2f7"; };
        hovered = { fg = "#1a1b26"; bg = "#7aa2f7"; };
        preview_hovered = { underline = true; };
        find_keyword = { fg = "#e0af68"; italic = true; };
        find_position = { fg = "#f7768e"; bg = "reset"; bold = true; };
        marker_selected = { fg = "#9ece6a"; bg = "reset"; bold = true; };
        tab_active = { fg = "#1a1b26"; bg = "#7aa2f7"; };
        tab_inactive = { fg = "#a9b1d6"; bg = "#24283b"; };
      };
    };
  };
}
