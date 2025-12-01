# /etc/nixos/SpidyNix/Homes/configs/niri.nix
{ config, pkgs, inputs, ... }:
{
  # Enable the Niri window manager session wrapper.
  programs.niri.enable = true;
  # Set session variables for Wayland compatibility.
  # This ensures applications launched from your shell run correctly on Wayland.
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";  # Use Wayland for Qt applications
    SDL_VIDEODRIVER = "wayland";  # Use Wayland for SDL applications
    XDG_SESSION_TYPE = "wayland";  # Set session type to Wayland
  };

  # Niri Configuration
  programs.niri.settings = {
    # Path where screenshots will be saved.
    screenshot-path = "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";

    # ============================================================================
    # ENVIRONMENT & STARTUP
    # ============================================================================
    # Set environment variables for applications to ensure they run correctly on Wayland.
    environment = {
      # Enable Wayland support for various toolkits.
      CLUTTER_BACKEND = "wayland";  # Use Wayland for Clutter applications
      DISPLAY = null;  # Unset DISPLAY for Wayland
      GDK_BACKEND = "wayland,x11";  # Use Wayland for GDK applications, fallback to X11
      MOZ_ENABLE_WAYLAND = "1";  # Enable Wayland for Mozilla applications
      NIXOS_OZONE_WL = "1";  # Enable Wayland for NixOS applications
      SDL_VIDEODRIVER = "wayland";  # Use Wayland for SDL applications
    };

    # Commands to run when Niri starts.
    spawn-at-startup = [
      { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }  # Watch clipboard for history
      { command = [ "wl-paste" "--type text" "--watch" "cliphist" "store" ]; }  # Watch clipboard for text history
      # 'qs' is a quick settings utility. You may need to install it.
      { command = [ "qs" "-c" "dms" ]; }  # Quick settings for DMS
    ];

    # ============================================================================
    # INPUT CONFIGURATION
    # ============================================================================
    input = {
      keyboard = {
        # Keyboard layout - configurable via user preferences
        xkb = {
          layout = "us";  # User-configurable layout
          variant = "us";  # User-configurable variant
          # Map Caps Lock to the Super/Mod key for easy access.
          options = "caps:super";  # Map Caps Lock to Super key
        };
        repeat-delay = 600;  # Key repeat delay
        repeat-rate = 25;  # Key repeat rate
      };
      touchpad = {
        click-method = "button-areas";  # Click method
        dwt = true;  # Disable touchpad while typing
        dwtp = true;  # Disable touchpad while pointing
        natural-scroll = true;  # Enable natural scrolling
        scroll-method = "two-finger";  # Scroll method
        tap = true;  # Enable tap to click
        tap-button-map = "left-right-middle";  # Tap button mapping
        middle-emulation = true;  # Enable middle click emulation
        accel-profile = "adaptive";  # Acceleration profile
      };
      mouse = {
        natural-scroll = true;  # Enable natural scrolling
      };
      focus-follows-mouse = {
        enable = true;  # Enable focus follows mouse
        max-scroll-amount = "90%";  # Maximum scroll amount
      };
      warp-mouse-to-focus.enable = true;  # Enable mouse warp to focus
      workspace-auto-back-and-forth = true;  # Enable workspace auto back and forth
    };

    # ============================================================================
    # OUTPUTS (MONITORS)
    # ============================================================================
    # Configure your monitors. This example sets up a primary display 'DP-1' at 170Hz.
    # You may need to adjust the resolution and mode to match your hardware.
    outputs = {
      "DP-1" = {
        # IMPORTANT: Change the resolution to match your monitor's native resolution.
        mode = {
          width = 1920;  # Monitor width
          height = 1080;  # Monitor height
          refresh = 170.000;  # Refresh rate
        };
        scale = 1.0;  # Monitor scale
        position = { x = 0; y = 0; };  # Monitor position
      };
    };

    # Cursor and gesture settings.
    cursor = { size = 20; };  # Cursor size
    gestures = { hot-corners.enable = true; };  # Enable hot corners

    # ============================================================================
    # LAYOUT CONFIGURATION
    # ============================================================================
    layout = {
      # Use a nice color scheme for borders.
      # If you use Stylix, you can replace these with ${base0B} and ${base0F}.
      border = {
        enable = true;  # Enable border
        width = 2;  # Border width
        active.color = "#a6e3a1";  # Active border color
        inactive.color = "#585b70";  # Inactive border color
      };
      focus-ring.enable = false;  # Disable focus ring
      shadow.enable = false;  # Disable shadow
      gaps = 6;  # Gaps between windows
      struts = { left = 0; right = 0; top = 0; bottom = 0; };  # Struts
      center-focused-column = "always";  # Center focused column
      preset-column-widths = [
        { proportion = 0.25; }  # 25% width
        { proportion = 0.5; }  # 50% width
        { proportion = 0.75; }  # 75% width
        { proportion = 1.0; }  # 100% width
      ];
      default-column-width = { proportion = 0.5; };  # Default column width
      tab-indicator = {
        hide-when-single-tab = true;  # Hide tab indicator when single tab
        place-within-column = true;  # Place tab indicator within column
        position = "left";  # Tab indicator position
        corner-radius = 20.0;  # Tab indicator corner radius
        gap = -12.0;  # Tab indicator gap
        gaps-between-tabs = 10.0;  # Gaps between tabs
        width = 4.0;  # Tab indicator width
        length.total-proportion = 0.1;  # Tab indicator length
      };
    };

    # ============================================================================
    # WINDOW RULES
    # ============================================================================
    # This uses the correct `matches` syntax for defining rules.
    window-rules = [
      # Give all windows rounded corners
      # The CORRECT syntax for geometry-corner-radius is a set of attributes for each corner.
      {
        geometry-corner-radius = {
          top-left = 12.0;  # Top left corner radius
          top-right = 12.0;  # Top right corner radius
          bottom-left = 12.0;  # Bottom left corner radius
          bottom-right = 12.0;  # Bottom right corner radius
        };
        clip-to-geometry = true;  # Clip to geometry
        draw-border-with-background = false;  # Draw border with background
      }
      # Enable shadows for floating windows
      { matches = [ { is-floating = true; } ]; shadow.enable = true; }  # Enable shadow for floating windows
      # Specific application rules
      { matches = [ { app-id = "pavucontrol"; } ]; open-floating = true; }  # Open pavucontrol as floating
      { matches = [ { app-id = "pavucontrol-qt"; } ]; open-floating = true; }  # Open pavucontrol-qt as floating
      { matches = [ { app-id = "com.saivert.pwvucontrol"; } ]; open-floating = true; }  # Open pwvucontrol as floating
      { matches = [ { app-id = "org.gnome.FileRoller"; } ]; open-floating = true; }  # Open file roller as floating
      { matches = [ { app-id = "nm-connection-editor"; } ]; open-floating = true; }  # Open network manager as floating
      { matches = [ { app-id = "blueman-manager"; } ]; open-floating = true; }  # Open blueman manager as floating
      { matches = [ { app-id = "xdg-desktop-portal-gtk"; } ]; open-floating = true; }  # Open xdg desktop portal as floating
      { matches = [ { app-id = "pinentry"; } ]; open-floating = true; }  # Open pinentry as floating
      { matches = [ { title = "Progress"; } ]; open-floating = true; }  # Open progress dialog as floating
      { matches = [ { title = "Confirm"; } ]; open-floating = true; }  # Open confirm dialog as floating
      { matches = [ { title = "Authentication Required"; } ]; open-floating = true; }  # Open authentication dialog as floating
      { matches = [ { title = "Error"; } ]; open-floating = true; }  # Open error dialog as floating
    ];

    # ============================================================================
    # KEYBINDINGS (COLEMAK DH FRIENDLY)
    # ============================================================================
    # Super is the Mod key (mapped to Caps Lock).
    # Navigation is remapped for Colemak DH: N=Left, E=Down, I=Up, O=Right.
    binds = {
      # --- System Actions ---
      "Super+Q".action.quit = { };  # Quit Niri
      "Super+Shift+Q".action.close-window = { };  # Close focused window
      "Super+Shift+R".action.spawn = [ "niri" "msg" "debug" "reconfigure" ];  # Reconfigure Niri

      # --- Application Launchers ---
      "Super+Return".action.spawn = [ "kitty" ];  # Launch Kitty terminal
      "Super+Space".action.spawn = [ "fuzzel" ];  # Launch Fuzzel application launcher

      # --- Window Focus (Colemak DH Navigation) ---
      "Super+N".action.focus-column-left = { };  # Focus left column
      "Super+E".action.focus-window-down = { };  # Focus down window
      "Super+I".action.focus-window-up = { };  # Focus up window
      "Super+O".action.focus-column-right = { };  # Focus right column
      # Arrow keys for navigation
      "Super+Left".action.focus-column-left = { };  # Focus left column
      "Super+Down".action.focus-window-down = { };  # Focus down window
      "Super+Up".action.focus-window-up = { };  # Focus up window
      "Super+Right".action.focus-column-right = { };  # Focus right column

      # --- Window Movement (Colemak DH) ---
      "Super+Shift+N".action.move-column-left = { };  # Move column left
      "Super+Shift+E".action.move-window-down = { };  # Move window down
      "Super+Shift+I".action.move-window-up = { };  # Move window up
      "Super+Shift+O".action.move-column-right = { };  # Move column right

      # --- Window Resizing & Layouts ---
      "Super+Minus".action.set-column-width = "-10%";  # Decrease column width
      "Super+Plus".action.set-column-width = "+10%";  # Increase column width
      "Super+Shift+Space".action.toggle-window-floating = { };  # Toggle window floating
      "Super+F".action.fullscreen-window = { };  # Toggle fullscreen for the focused window
      "Super+Shift+F".action.expand-column-to-available-width = { };  # Expand column to available width
      "Super+S".action.switch-preset-column-width = { };  # Switch preset column width
      "Super+W".action.toggle-column-tabbed-display = { };  # Toggle column tabbed display
      "Super+Comma".action.consume-window-into-column = { };  # Consume window into column
      "Super+Period".action.expel-window-from-column = { };  # Expel window from column
      "Super+C".action.center-visible-columns = { };  # Center visible columns
      "Super+Tab".action.switch-focus-between-floating-and-tiling = { };  # Switch focus between floating and tiling

      # --- Workspace Management ---
      "Super+1".action.focus-workspace = 1;  # Focus workspace 1
      "Super+2".action.focus-workspace = 2;  # Focus workspace 2
      "Super+3".action.focus-workspace = 3;  # Focus workspace 3
      "Super+4".action.focus-workspace = 4;  # Focus workspace 4
      "Super+5".action.focus-workspace = 5;  # Focus workspace 5
      "Super+6".action.focus-workspace = 6;  # Focus workspace 6
      "Super+7".action.focus-workspace = 7;  # Focus workspace 7
      "Super+8".action.focus-workspace = 8;  # Focus workspace 8
      "Super+9".action.focus-workspace = 9;  # Focus workspace 9

      "Super+Shift+1".action.move-column-to-workspace = 1;  # Move column to workspace 1
      "Super+Shift+2".action.move-column-to-workspace = 2;  # Move column to workspace 2
      "Super+Shift+3".action.move-column-to-workspace = 3;  # Move column to workspace 3
      "Super+Shift+4".action.move-column-to-workspace = 4;  # Move column to workspace 4
      "Super+Shift+5".action.move-column-to-workspace = 5;  # Move column to workspace 5
      "Super+Shift+6".action.move-column-to-workspace = 6;  # Move column to workspace 6
      "Super+Shift+7".action.move-column-to-workspace = 7;  # Move column to workspace 7
      "Super+Shift+8".action.move-column-to-workspace = 8;  # Move column to workspace 8
      "Super+Shift+9".action.move-column-to-workspace = 9;  # Move column to workspace 9

      # --- Media Controls (using 'qs' if available, otherwise standard tools) ---
      "XF86AudioRaiseVolume".action.spawn = [ "pamixer" "--increase" "5" ];  # Increase volume
      "XF86AudioLowerVolume".action.spawn = [ "pamixer" "--decrease" "5" ];  # Decrease volume
      "XF86AudioMute".action.spawn = [ "pamixer" "--toggle-mute" ];  # Toggle mute
      "XF86AudioPlay".action.spawn = [ "playerctl" "play-pause" ];  # Play/pause
      "XF86AudioNext".action.spawn = [ "playerctl" "next" ];  # Next track
      "XF86AudioPrev".action.spawn = [ "playerctl" "previous" ];  # Previous track
      "XF86MonBrightnessUp".action.spawn = [ "brightnessctl" "set" "+5%" ];  # Increase brightness
      "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "set" "5-" ];  # Decrease brightness

      # --- Screenshots ---
      "Print".action.screenshot-screen = { write-to-disk = true; };  # Take screenshot of screen
      "Super+Shift+S".action.screenshot = { show-pointer = false; };  # Take screenshot
    };
  };
}
# ============================================================================
# NIRI WINDOW MANAGER CONFIGURATION
# ============================================================================
# This file configures the Niri window manager for user 'spidy'.
# Niri is a scrollable tiling Wayland compositor.
#
# Home Manager module for Niri configuration.
# ============================================================================
# ============================================================================
# NOTES
# ============================================================================
# USAGE:
# - Launch: niri
# - Configuration: ~/.config/niri/config.toml
# - Logs: ~/.local/share/niri/niri.log
#
# KEYBINDINGS:
# - Super+Q: Quit Niri
# - Super+Shift+Q: Close focused window
# - Super+Return: Launch Kitty terminal
# - Super+Space: Launch Fuzzel application launcher
# - Super+N/E/I/O: Focus left/down/up/right
# - Super+Shift+N/E/I/O: Move column left/down/up/right
# - Super+Minus/Plus: Decrease/increase column width
# - Super+Shift+Space: Toggle window floating
# - Super+F: Toggle fullscreen for the focused window
# - Super+Shift+F: Expand column to available width
# - Super+S: Switch preset column width
# - Super+W: Toggle column tabbed display
# - Super+Comma/Period: Consume/expel window from column
# - Super+C: Center visible columns
# - Super+Tab: Switch focus between floating and tiling
# - Super+1-9: Focus workspace 1-9
# - Super+Shift+1-9: Move column to workspace 1-9
# - XF86AudioRaiseVolume: Increase volume
# - XF86AudioLowerVolume: Decrease volume
# - XF86AudioMute: Toggle mute
# - XF86AudioPlay: Play/pause
# - XF86AudioNext: Next track
# - XF86AudioPrev: Previous track
# - XF86MonBrightnessUp: Increase brightness
# - XF86MonBrightnessDown: Decrease brightness
# - Print: Take screenshot of screen
# - Super+Shift+S: Take screenshot
#
# CONFIGURATION:
# - Config file: ~/.config/niri/config.toml
# - Themes: ~/.config/niri/themes/
# - Keybindings: ~/.config/niri/keybindings.toml
#
# LEARNING:
# - :help - Built-in help
# - :tutor - Interactive tutorial
# - :checkhealth - Check configuration
# ============================================================================
