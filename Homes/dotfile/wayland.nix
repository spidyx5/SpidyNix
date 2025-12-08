{ config, pkgs, lib, ... }:

{
  # =========================================================================
  # WAYLAND SESSION VARIABLES (User-specific)
  # =========================================================================
  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";

    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    SDL_VIDEODRIVER = "wayland";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DBUS_REMOTE = "1";

    CLUTTER_BACKEND = "wayland";
    ECORE_EVAS_ENGINE = "wayland-egl";
    ELM_ENGINE = "wayland_egl";
    # DISPLAY is not used in Wayland sessions
    GDK_BACKEND = "wayland,x11";
    NIXOS_OZONE_WL = "1";

    _JAVA_AWT_WM_NONREPARENTING = "1";

    LIBGL_ALWAYS_INDIRECT = "0";

    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # =========================================================================
  # ENVIRONMENT INITIALIZATION (User-specific)
  # =========================================================================
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.shellAliases = {
    # Add any shell-specific Wayland aliases here if needed
  };
}
