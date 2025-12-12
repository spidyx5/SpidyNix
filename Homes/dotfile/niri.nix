{ config, pkgs, lib, inputs, ... }:

{
  # =========================================================================
  # NIRI WINDOW MANAGER CONFIGURATION
  # =========================================================================
  programs.niri = {
    settings = {
      screenshot-path = "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";

      # ===================================================================
      # INPUT CONFIGURATION
      # ===================================================================
      input = {
        keyboard = {
          xkb = {
            layout = "us";
            variant = "qwerty";
            options = "caps:super";
          };
          repeat-delay = 400;
          repeat-rate = 25;
        };
        touchpad = {
          click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
        };
        mouse = {
          natural-scroll = false;
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "90%";
        };
        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
      };

      # ===================================================================
      # OUTPUTS (MONITORS)
      # ===================================================================
      outputs = {
        "DP-2" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 170.000;
          };
          scale = 1.0;
          position = { x = 0; y = 0; };
        };
      };

      cursor = { size = 20; };
      gestures = { hot-corners.enable = true; };

      # ===================================================================
      # LAYOUT CONFIGURATION
      # ===================================================================
      layout = {
        border = {
          enable = true;
          width = 2;
          active.color = "#a6e3a1";
          inactive.color = "#585b70";
        };
        focus-ring.enable = false;
        shadow.enable = false;
        gaps = 6;
        struts = { left = 0; right = 0; top = 0; bottom = 0; };
        center-focused-column = "always";
        preset-column-widths = [
          { proportion = 0.25; }
          { proportion = 0.5; }
          { proportion = 0.75; }
          { proportion = 1.0; }
        ];
        default-column-width = { proportion = 0.5; };
        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
          position = "left";
          corner-radius = 20.0;
          gap = -12.0;
          gaps-between-tabs = 10.0;
          width = 4.0;
          length.total-proportion = 0.1;
        };
      };

      # ===================================================================
      # WINDOW RULES
      # ===================================================================
      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
        { matches = [ { is-floating = true; } ]; shadow.enable = true; }
        { matches = [ { app-id = "pavucontrol"; } ]; open-floating = true; }
        { matches = [ { app-id = "pavucontrol-qt"; } ]; open-floating = true; }
        { matches = [ { app-id = "com.saivert.pwvucontrol"; } ]; open-floating = true; }
        { matches = [ { app-id = "org.gnome.FileRoller"; } ]; open-floating = true; }
        { matches = [ { app-id = "nm-connection-editor"; } ]; open-floating = true; }
        { matches = [ { app-id = "blueman-manager"; } ]; open-floating = true; }
        { matches = [ { app-id = "xdg-desktop-portal-wlr"; } ]; open-floating = true; }
        { matches = [ { app-id = "pinentry"; } ]; open-floating = true; }
        { matches = [ { title = "Progress"; } ]; open-floating = true; }
        { matches = [ { title = "Confirm"; } ]; open-floating = true; }
        { matches = [ { title = "Authentication Required"; } ]; open-floating = true; }
        { matches = [ { title = "Error"; } ]; open-floating = true; }
      ];

      binds = {
        "Super+Q".action.quit = { };
        "Super+Shift+Q".action.close-window = { };
        "Super+Shift+R".action.spawn = [ "niri" "msg" "debug" "reconfigure" ];

        "Super+Return".action.spawn = [ "ghostty" ];
        "Super+Space".action.spawn = [ "fuzzel" ];

        # Navigation (QWERTY - will be Colemak DH when keyd remaps)
        "Super+H".action.focus-column-left = { };
        "Super+J".action.focus-window-down = { };
        "Super+K".action.focus-window-up = { };
        "Super+L".action.focus-column-right = { };

        "Super+Left".action.focus-column-left = { };
        "Super+Down".action.focus-window-down = { };
        "Super+Up".action.focus-window-up = { };
        "Super+Right".action.focus-column-right = { };

        # Movement
        "Super+Shift+H".action.move-column-left = { };
        "Super+Shift+J".action.move-window-down = { };
        "Super+Shift+K".action.move-window-up = { };
        "Super+Shift+L".action.move-column-right = { };

        # Resizing & Layouts
        "Super+Minus".action.set-column-width = "-10%";
        "Super+Plus".action.set-column-width = "+10%";
        "Super+Shift+Space".action.toggle-window-floating = { };
        "Super+F".action.fullscreen-window = { };
        "Super+Shift+F".action.expand-column-to-available-width = { };
        "Super+S".action.switch-preset-column-width = { };
        "Super+W".action.toggle-column-tabbed-display = { };
        "Super+Comma".action.consume-window-into-column = { };
        "Super+Period".action.expel-window-from-column = { };
        "Super+C".action.center-visible-columns = { };
        "Super+Tab".action.switch-focus-between-floating-and-tiling = { };

        # Workspaces
        "Super+1".action.focus-workspace = 1;
        "Super+2".action.focus-workspace = 2;
        "Super+3".action.focus-workspace = 3;
        "Super+4".action.focus-workspace = 4;
        "Super+5".action.focus-workspace = 5;
        "Super+6".action.focus-workspace = 6;
        "Super+7".action.focus-workspace = 7;
        "Super+8".action.focus-workspace = 8;
        "Super+9".action.focus-workspace = 9;

        "Super+Shift+1".action.move-column-to-workspace = 1;
        "Super+Shift+2".action.move-column-to-workspace = 2;
        "Super+Shift+3".action.move-column-to-workspace = 3;
        "Super+Shift+4".action.move-column-to-workspace = 4;
        "Super+Shift+5".action.move-column-to-workspace = 5;
        "Super+Shift+6".action.move-column-to-workspace = 6;
        "Super+Shift+7".action.move-column-to-workspace = 7;
        "Super+Shift+8".action.move-column-to-workspace = 8;
        "Super+Shift+9".action.move-column-to-workspace = 9;

        # Media Controls - Noctalia integration
        "XF86AudioRaiseVolume".action.spawn = [ "noctalia-shell" "ipc" "call" "volume" "increase" ];
        "XF86AudioLowerVolume".action.spawn = [ "noctalia-shell" "ipc" "call" "volume" "decrease" ];
        "XF86AudioMute".action.spawn = [ "noctalia-shell" "ipc" "call" "volume" "muteOutput" ];
        "XF86AudioPlay".action.spawn = [ "playerctl" "play-pause" ];
        "XF86AudioNext".action.spawn = [ "playerctl" "next" ];
        "XF86AudioPrev".action.spawn = [ "playerctl" "previous" ];
        "XF86MonBrightnessUp".action.spawn = [ "brightnessctl" "set" "+5%" ];
        "XF86MonBrightnessDown".action.spawn = [ "brightnessctl" "set" "5-" ];

        # Noctalia shortcuts
        "Mod+L".action.spawn = [ "noctalia-shell" "ipc" "call" "lockScreen" "toggle" ];
        "Mod+Space".action.spawn = [ "noctalia-shell" "ipc" "call" "launcher" "toggle" ];
        "Mod+P".action.spawn = [ "noctalia-shell" "ipc" "call" "sessionMenu" "toggle" ];

        # Screenshots
        "Print".action.screenshot-screen = { write-to-disk = true; };
        "Super+Shift+S".action.screenshot = { show-pointer = false; };
      };
    };
  };
}