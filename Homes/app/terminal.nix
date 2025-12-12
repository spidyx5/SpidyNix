{ config, pkgs, lib, ... }:

# ============================================================================
# SPIDYNIX STARSHIP PROMPT CONFIGURATION
# ============================================================================
# Custom prompt with Git info, Nix shell, and transient behavior
# Optimized for Nushell and Wayland
# ============================================================================

{
  programs.starship = {
    enable = true;
    enableTransience = true;

    settings = {
      add_newline = true;
      scan_timeout = 10;

      format = ''
        [╭──╼](bold bright-blue) $hostname $os
        [┆](bold bright-blue) $directory$git_branch$git_commit$git_state$git_metrics$git_status$nix_shell
        [╰─>](bold bright-blue) $character
      '';

      os = {
        format = "on [($name $codename$version $symbol )]($style)";
        style = "bold bright-blue";
        disabled = false;
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style)";
        style = "bold bright-red";
        disabled = false;
      };

      character = {
        format = "$symbol";
        success_symbol = "[❯](bold bright-green)";
        error_symbol = "[✗](bold bright-red) ";
        disabled = false;
      };

      time = {
        disabled = false;
        format = " [$time]($style)";
        time_format = "%H:%M";
        utc_time_offset = "local";
        style = "pale bright-blue";
      };

      cmd_duration = {
        disabled = false;
        min_time = 250;
        show_milliseconds = false;
        show_notifications = false;
        format = "was [$duration](bold green)";
      };

      nix_shell = {
        disabled = false;
        heuristic = false;
        format = "[   ](fg:bright-blue bold)";
        impure_msg = "";
        pure_msg = "";
        unknown_msg = "";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    clearDefaultKeybinds = true;
    settings = {
      theme = "noctalia";

      scrollback-limit = 10000;

      font-family = "SF-Mono";
      font-size = 10;
      cursor-style = "bar";
      cursor-style-blink = true;
      window-padding-x = 15;
      window-padding-y = 6;
      desktop-notifications = true;
      resize-overlay = "never";
      window-decoration = "none";
      bell-features = "audio";

      confirm-close-surface = false;
      gtk-single-instance = true;
      quit-after-last-window-closed = false;
      # initial-window = false;

      adjust-cursor-height = "40%";
      adjust-cursor-thickness = "100%";
      adjust-box-thickness = "100%";
      adjust-underline-thickness = "100%";
      adjust-underline-position = "110%";
      keybind = [
        "ctrl+d=inspector:toggle"
        "ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+plus=increase_font_size:1"
        "ctrl+0=reset_font_size"
        "ctrl+r=reload_config"
        "alt+v=new_split:right"
        "alt+s=new_split:down"
        "alt+h=goto_split:left"
        "alt+l=goto_split:right"
        "alt+j=goto_split:bottom"
        "alt+k=goto_split:top"
        "alt+n=new_tab"
      ];
    };
  };
}
