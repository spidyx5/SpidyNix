# /etc/nixos/SpidyNix/Systems/login.nix
{ config, pkgs, lib, inputs, ... }:
{
  # Enable greetd login manager
  services.greetd = {
    enable = true;

    settings = {
      # Configure default session to use ReGreet greeter
      default_session = {
        # Using lib.getExe is the modern way to get the path to a package's executable
        command = "${lib.getExe pkgs.regreet}";
        user = "greeter";
      };
    };
  };

  # Enable ReGreet login manager with default settings
  programs.regreet = {
    enable = true;
    # NOTE: We are NOT setting any themes, fonts, or backgrounds here.
    # ReGreet will use its built-in default theme, which is guaranteed to work.
    # You can customize this later once you confirm the basic setup is working.
  };

  # ============================================================================
  # SESSIONS
  # ============================================================================
  # This file tells greetd which desktop environments or shells are available
  # for the user to select from the login screen.
  # ============================================================================

  environment.etc."greetd/environments".text = ''
    niri-session
    bash
    zsh
    fish
  '';

  # ============================================================================
  # SYSTEMD & ENVIRONMENT
  # ============================================================================
  # Set necessary environment variables for a Wayland session.
  # ============================================================================

  systemd.services.greetd = {
    environment = {
      # Tells applications that this is a Wayland session
      XDG_SESSION_TYPE = "wayland";
      # Helps desktop environments and other tools identify the session
      XDG_SESSION_DESKTOP = "niri";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };
}
# NOTES
# ============================================================================
# GREETD:
# - Minimal login manager (similar to LightDM, GDM, SDDM)
# - No X11 dependency
# - Works with any greeter
# - Very flexible and lightweight
# - Configuration: /etc/greetd/config.toml
#
# REGREET:
# - GTK-based greeter for greetd
# - Clean, modern interface
# - Theme support
# - Session selection
# - Power management (shutdown, reboot)
# - Alternative to tuigreet, gtkgreet, etc.
#
# INITIAL SESSION:
# - Automatically starts session for user
# - Only runs on first VT
# - Useful for single-user systems
# - Comment out for multi-user systems
# - More secure to leave disabled
#
# AUTO-LOGIN:
# - Configured in service.nix via displayManager.autoLogin
# - Skips login screen entirely
# - Less secure but more convenient
# - Not recommended for shared systems
#
# SESSIONS:
# - Available sessions listed in /etc/greetd/environments
# - Can add custom sessions
# - Niri is the default session
# - Users can select alternative shells
#
# VT (VIRTUAL TERMINAL):
# - greetd runs on VT 1 by default
# - User sessions start on VT 2+
# - Switch VTs: Ctrl+Alt+F1, F2, etc.
#
# THEMES:
# - ReGreet uses GTK themes
# - Dark theme enabled by default
# - Customize in programs.regreet.settings.GTK
# - Install additional themes via environment.systemPackages
#
# BACKGROUND:
# - Set custom background in regreet settings
# - path: "/path/to/wallpaper.jpg"
# - fit: "Cover", "Contain", "Fill", "ScaleDown"
# - null means no background image
#
# WAYLAND COMPOSITORS:
# - Niri: Scrollable tiling Wayland compositor
# - Can also use: Sway, Hyprland, River, etc.
# - Add to /etc/greetd/environments
#
# X11 SESSIONS:
# - greetd can launch X11 sessions too
# - Add "startx" or specific X session to environments
# - But this config focuses on Wayland
#
# TROUBLESHOOTING:
# - Black screen: Check journalctl -u greetd
# - Wrong session: Check /etc/greetd/environments
# - Theme issues: Install GTK themes
# - Login loop: Check user groups and permissions
# - No keyboard: Check input device permissions
#
# DEBUGGING:
# - greetd logs: journalctl -u greetd
# - regreet logs: Check syslog or journalctl
# - Manual test: sudo greetd --vt 2 --config /etc/greetd/config.toml
# - Check config: cat /etc/greetd/config.toml
#
# SECURITY:
# - Greeter runs as unprivileged user
# - PAM authentication
# - Polkit for power management
# - No remote login by default
#
# POWER MANAGEMENT:
# - Shutdown button in greeter
# - Reboot button in greeter
# - Requires polkit permissions
# - Configured above in polkit.extraConfig
#
# ALTERNATIVE GREETERS:
# - tuigreet: TUI (terminal) greeter
# - gtkgreet: Simple GTK greeter
# - agreety: Minimal text greeter
# - wlgreet: Wayland greeter
# - Change: services.greetd.settings.default_session.command
#
# SWITCHING TO TUIGREET:
# services.greetd.settings.default_session.command =
#   "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
#
# MULTIPLE MONITORS:
# - ReGreet should detect all monitors
# - Greeter appears on primary monitor
# - Set primary in compositor config if needed
#
# ACCESSIBILITY:
# - GTK accessibility features available
# - Screen reader support via GTK
# - High contrast themes available
# - Font size adjustable in GTK settings
#
# CUSTOM GREETING MESSAGE:
# - Set in programs.regreet.settings.appearance.greeting_msg
# - Can include date/time formatting
# - Supports Unicode characters
#
# SESSION SELECTION:
# - User can select session at login
# - Sessions from /etc/greetd/environments
# - Last used session remembered per user
#
# LANGUAGE SUPPORT:
# - ReGreet uses system locale
# - GTK translations included
# - Keyboard layouts from X11/Wayland config
#
# PERFORMANCE:
# - Very lightweight
# - Fast startup
# - Low memory usage
# - Minimal CPU usage when idle
#
# COMPARISON:
# - vs GDM: Much lighter, no GNOME deps
# - vs SDDM: More flexible, easier config
# - vs LightDM: More modern, Wayland-native
# - vs ly: More features, GUI instead of TUI
#
# CUSTOMIZATION:
# - GTK CSS for advanced styling
# - Custom backgrounds
# - Logo/branding
# - Theme integration
#
# USER SWITCHING:
# - Fast user switching supported
# - Each user gets own VT
# - Switch: loginctl list-sessions
# - Switch to session: loginctl activate SESSION_ID
#
# REMOTE ACCESS:
# - For remote login, use SSH (configured in network.nix)
# - greetd is for local login only
# - No VNC/RDP by default
#
# BACKUP GREETER:
# - If regreet fails, greetd falls back to terminal
# - Can always login via TTY (Ctrl+Alt+F2)
# - Emergency access maintained
#
# TESTING CHANGES:
# 1. sudo nixos-rebuild switch
# 2. sudo systemctl restart greetd
# 3. Check logs: journalctl -u greetd -f
# 4. Test login on new session
#
# DISABLING AUTO-RESTART:
# - Set services.greetd.restart = false
# - Useful for debugging
# - Not recommended for production
# ============================================================================
