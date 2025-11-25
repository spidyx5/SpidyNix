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
  };

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
    kdePackages.qt5compat
    kdePackages.qtwebengine
    # ==========================================================================
    # WAYLAND & DISPLAY
    # ==========================================================================
    # Core Utilities
    wayland                              # Wayland protocol libraries
    wayland-utils                        # Wayland utilities (wayland-info, etc.)
    wayland-protocols                    # Wayland protocol extensions
    xwayland-satellite                   # XWayland integration
    wtype
    wlr-randr
    wev
    wdisplays             # GUI display configurator
    kanshi                # Dynamic display configuration
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    python3Packages.anyqt
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
  # ============================================================================
  # WAYLAND CONFIGURATION NOTES
  # ============================================================================
  # This file configures Wayland support including:
  # - Environment variables for Wayland applications
  # - XDG Desktop Portal configuration
  # - Core Wayland utilities and protocols
  # - Qt compatibility packages for Wayland
  # ============================================================================

  # WAYLAND COMPOSITORS:
  # - Niri: Scrollable tiling compositor (configured in home.nix)
  # - Sway: i3-compatible tiling compositor
  # - Hyprland: Dynamic tiling with animations
  # - River: Dynamic tiling Wayland compositor
  # - Wayfire: 3D compositor with wobbly windows

  # KEY ENVIRONMENT VARIABLES:
  # - XDG_SESSION_TYPE: Sets Wayland as session type
  # - QT_QPA_PLATFORM: Tells Qt apps to use Wayland (fallback to XCB)
  # - SDL_VIDEODRIVER: Uses Wayland for SDL applications
  # - MOZ_ENABLE_WAYLAND: Enables Wayland for Firefox-based browsers

  # XDG DESKTOP PORTAL:
  # - Handles screen sharing, file choosers, etc.
  # - xdg-desktop-portal-wlr: For wlroots-based compositors
  # - xdg-desktop-portal-gtk: GTK file chooser
  # - Configured for Niri with wlr for screencast/screenshot

  # TROUBLESHOOTING TIPS:
  # - App not using Wayland: Verify XDG_SESSION_TYPE is set correctly
  # - Qt apps look wrong: Ensure QT_QPA_PLATFORMTHEME is set properly
  # - Screen sharing issues: Check xdg-desktop-portal configuration
  # - Clipboard problems: Verify wl-clipboard is installed
  # - Debug Wayland events: Use 'wev' command

  # PERFORMANCE BENEFITS:
  # - Lower latency than X11
  # - Better gaming support (VRR)
  # - Enhanced security (no keylogging between windows)
  # - Improved multi-monitor handling

  # COMPATIBILITY NOTES:
  # - Most applications now support Wayland natively
  # - XWayland provides compatibility for X11 applications
  # - Some applications need specific environment variables
  # - Electron apps may need: --enable-features=UseOzonePlatform --ozone-platform=wayland

  # FUTURE CONSIDERATIONS:
  # - Consider adding more Wayland-specific tools as needed
  # - Monitor Wayland protocol updates for new features
  # - Keep an eye on compositor updates for new capabilities
  # - Consider adding Vulkan support for better graphics performance
  # - Explore Wayland-specific security features as they develop
  # ============================================================================
