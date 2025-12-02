# /etc/nixos/SpidyNix/Softwares/wayland.nix
{ config, pkgs, lib, inputs, ... }:
{
  environment.sessionVariables = {
    # Wayland session configuration
    XDG_SESSION_TYPE = "wayland";        # Set Wayland as session type
    XDG_CURRENT_DESKTOP = "niri";        # Current desktop environment

    # Qt application settings
    QT_QPA_PLATFORM = "wayland;xcb";     # Prefer Wayland, fallback to XCB
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";  # Disable Qt window decorations
   # QT_QPA_PLATFORMTHEME = "gtk4";       # Use GTK theme for Qt apps

    # SDL application settings
    SDL_VIDEODRIVER = "wayland";         # Use Wayland for SDL apps

    # Mozilla/Firefox settings
    MOZ_ENABLE_WAYLAND = "1";            # Enable Wayland for Firefox
    MOZ_DBUS_REMOTE = "1";               # Enable DBus remote for Firefox

    # Graphics library settings
    CLUTTER_BACKEND = "wayland";        # Use Wayland for Clutter
    ECORE_EVAS_ENGINE = "wayland-egl";   # Use Wayland EGL for Elementary
    ELM_ENGINE = "wayland_egl";          # Use Wayland EGL for Elementary

    # Java application settings
    _JAVA_AWT_WM_NONREPARENTING = "1";   # Fix Java apps on tiling WMs

    # OpenGL and Mesa settings for performance
    #__EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa_git}/share/glvnd/egl_vendor.d/50_mesa_git.json";
    LIBGL_ALWAYS_INDIRECT = "0";

    # Electron application settings for Wayland
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
   };

   # Prepend OpenGL driver to LD_LIBRARY_PATH
   environment.extraInit = ''
     export LD_LIBRARY_PATH="/run/opengl-driver/lib:$LD_LIBRARY_PATH"
   '';

  # XDG Desktop Portal configuration
  xdg.portal = {
    enable = true;                      # Enable XDG portal
    xdgOpenUsePortal = true;             # Use portal for xdg-open

    # Portals for Wayland compositors
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr             # For wlroots-based compositors
      xdg-desktop-portal-gtk             # GTK file chooser
    ];

    # Default portal implementations
    config = {
      common = {
        default = [ "gtk" ];            # Default to GTK portal
      };
      niri = {
        default = [ "gtk" ];            # Default to GTK portal for Niri
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];  # Use wlr for screencast
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];  # Use wlr for screenshots
      };
    };
  };

  # ============================================================================
  # QT PACKAGES FOR WAYLAND COMPATIBILITY
  # ============================================================================
  # Qt5/Qt6 packages for Wayland support and DMS compatibility
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Qt5 compatibility (for DMS)
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquick3d
    #libsForQt5.qt5.qtwebengine
    # ==========================================================================
    # WAYLAND & DISPLAY
    # ==========================================================================
    # Core Utilities
    wayland                              # Wayland protocol libraries
    wayland-utils                        # Wayland utilities (wayland-info, etc.)
    wayland-protocols                    # Wayland protocol extensions
    #xwayland-satellite                   # XWayland integration
    wtype
    wlr-randr
    wev
    wdisplays             # GUI display configurator
    kanshi                # Dynamic display configuration
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    python313Packages.anyqt
  ];
  # ============================================================================
  # Qt libraries available to dynamically linked programs
  # Removed duplicates that are now in environment.systemPackages above
  # ============================================================================
  programs.nix-ld.libraries = with pkgs; [
    libsForQt5.qtbase
    libsForQt5.qtwayland
    qt6.qtwayland
    # Qt6 dependencies for Quickshell
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qt5compat
    qt6.qtquick3d
    qt6Packages.qt6ct
  ];
}
