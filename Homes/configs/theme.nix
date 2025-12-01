# /etc/nixos/SpidyNix/Homes/configs/theme.nix
{ pkgs, config, ... }:
{
  # ============================================================================
  # GTK THEME CONFIGURATION
  # ============================================================================
  gtk = {
    enable = true;  # Enable GTK theme configuration

    theme = {
      name = "Tokyonight-Dark";  # Set GTK theme name
      package = pkgs.tokyonight-gtk-theme;  # Theme package
    };

    iconTheme = {
      name = "Papirus-Dark";  # Set icon theme name
      package = pkgs.papirus-icon-theme;  # Icon theme package
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";  # Set cursor theme name
      package = pkgs.bibata-cursors;  # Cursor theme package
      size = 24;  # Cursor size
    };

    # Force Dark Mode in GTK3/4 config files
    #gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    #gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # ============================================================================
  # DCONF SETTINGS (REQUIRED FOR GTK4 WAYLAND)
  # ============================================================================
  # This ensures apps like Nautilus/Settings use dark mode correctly
  # ============================================================================
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";  # Force dark mode in GNOME apps
    };
  };

  # ============================================================================
  # QT THEME CONFIGURATION
  # ============================================================================
  qt = {
    enable = true;  # Enable Qt theme configuration
    # Use GTK theme for Qt apps (Uniform look)
    platformTheme.name = "qtct";
    # 'adwaita-dark' or 'breeze' are safer modern defaults than 'gtk2'
    style.name = "adwaita-dark";
  };

  # ============================================================================
  # CURSOR SETTINGS (HYBRID WAYLAND/X11)
  # ============================================================================
  home.pointerCursor = {
    gtk.enable = true;  # Enable GTK cursor theme
    x11.enable = true;  # Crucial for XWayland apps (Steam, Electron)
    package = pkgs.bibata-cursors;  # Cursor theme package
    name = "Bibata-Modern-Ice";  # Cursor theme name
    size = 24;  # Cursor size
  };
}
# ============================================================================
# THEME CONFIGURATION
# ============================================================================
# Manual theming configuration for GTK, Qt, and Cursor.
# Uses Tokyonight Dark and Bibata Cursors.
# ============================================================================
# NOTES:
# - This configuration sets up a consistent dark theme across GTK and Qt applications
# - Cursor settings are configured for both Wayland and X11 compatibility
# - If you need to change themes, update both GTK and Qt theme settings
# - For troubleshooting theme issues, check:
#   - GTK theme: gsettings get org.gnome.desktop.interface gtk-theme
#   - Qt theme: Check QT_QPA_PLATFORMTHEME environment variable
#   - Cursor theme: gsettings get org.gnome.desktop.interface cursor-theme
# ============================================================================
