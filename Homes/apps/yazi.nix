# /etc/nixos/SpidyNix/Homes/apps/yazi.nix
{ pkgs, ... }:
{
  # Install Yazi package
  home.packages = with pkgs; [
    yazi  # Terminal file manager
  ];

  programs.yazi = {
    enable = true;  # Enable Yazi file manager
    enableNushellIntegration = true;  # Enable Nushell integration

    # ==========================================================================
    # MANAGER SETTINGS
    # ==========================================================================
    settings = {
      manager = {
        show_hidden = true;  # Show hidden files
        sort_by = "alphabetical";  # Sort by name
        sort_sensitive = false;  # Case-insensitive sorting
        sort_reverse = false;  # Don't reverse sort order
        sort_dir_first = true;  # Show directories first
        linemode = "none";  # No line numbers
        show_symlink = true;  # Show symlink targets
      };

      # ==========================================================================
      # PREVIEW SETTINGS
      # ==========================================================================
      preview = {
        tab_size = 2;  # Tab size for text previews
        max_width = 600;  # Max preview width
        max_height = 900;  # Max preview height
        cache_dir = "";  # Empty = use default cache
        image_filter = "lanczos3";  # Image scaling filter
        image_quality = 90;  # Image preview quality
        sixel_fraction = 15;  # Sixel image fraction
      };
    };

    # ==========================================================================
    # THEME SETTINGS (TokyoNight inspired)
    # ==========================================================================
    theme = {
      manager = {
        cwd = { fg = "#7aa2f7"; };  # Current directory color
        hovered = { fg = "#1a1b26"; bg = "#7aa2f7"; };  # Hovered item
        preview_hovered = { underline = true; };  # Preview hover underline
        find_keyword = { fg = "#e0af68"; italic = true; };  # Find keyword
        find_position = { fg = "#f7768e"; bg = "reset"; bold = true; };  # Find position
        marker_selected = { fg = "#9ece6a"; bg = "reset"; bold = true; };  # Selected marker
        tab_active = { fg = "#1a1b26"; bg = "#7aa2f7"; };  # Active tab
        tab_inactive = { fg = "#a9b1d6"; bg = "#24283b"; };  # Inactive tab
      };
    };
  };
}
# ============================================================================
# YAZI CONFIGURATION
# ============================================================================
# Configures Yazi file manager with TokyoNight theme and Nushell integration
# ============================================================================
# NOTES:
# - Yazi is a terminal-based file manager
# - TokyoNight theme provides consistent dark mode appearance
# - Nushell integration allows using Nu commands in Yazi
# - For troubleshooting:
#   - Check Yazi installation: which yazi
#   - Verify Nushell integration: yazi --version
#   - Check theme colors: yazi --theme
# - To customize:
#   - Change theme colors to match your preferred palette
#   - Adjust preview settings for better performance
#   - Modify sort settings for different file organization
# ============================================================================
