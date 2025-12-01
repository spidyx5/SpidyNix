# /etc/nixos/SpidyNix/Homes/devs/terminal.nix
{ config, pkgs, lib, ... }:
{
  # Install Starship package
  home.packages = with pkgs; [
    starship  # Cross-shell prompt
  ];

  # ============================================================================
  # STARSHIP - CROSS-SHELL PROMPT
  # ============================================================================
  # Modern, fast, customizable shell prompt
  # ============================================================================
  programs.starship = {
    enable = true;  # Enable Starship
    enableTransience = true;  # Enable transience

    settings = {
      add_newline = true;  # Add newline
      scan_timeout = 10;  # Scan timeout

      # Custom format
      format = ''
        [╭──╼](bold bright-blue) $hostname $os
        [┆](bold bright-blue) $directory$git_branch$git_commit$git_state$git_metrics$git_status$nix_shell
        [╰─>](bold bright-blue) $character
      '';

      # OS indicator
      os = {
        format = "on [($name $codename$version $symbol )]($style)";  # OS format
        style = "bold bright-blue";  # OS style
        disabled = false;  # OS disabled
      };

      # Hostname
      hostname = {
        ssh_only = false;  # Hostname SSH only
        format = "[$hostname]($style)";  # Hostname format
        style = "bold bright-red";  # Hostname style
        disabled = false;  # Hostname disabled
      };

      # Character (prompt symbol)
      character = {
        format = "$symbol";  # Character format
        success_symbol = "[❯](bold bright-green)";  # Success symbol
        error_symbol = "[✗](bold bright-red) ";  # Error symbol
        disabled = false;  # Character disabled
      };

      # Time
      time = {
        disabled = false;  # Time disabled
        format = " [$time]($style)";  # Time format
        time_format = "%H:%M";  # Time format
        utc_time_offset = "local";  # UTC time offset
        style = "pale bright-blue";  # Time style
      };

      # Command duration
      cmd_duration = {
        disabled = false;  # Command duration disabled
        min_time = 250;  # Min time
        show_milliseconds = false;  # Show milliseconds
        show_notifications = false;  # Show notifications
        format = "was [$duration](bold green)";  # Command duration format
      };

      # Nix shell indicator
      nix_shell = {
        disabled = false;  # Nix shell disabled
        heuristic = false;  # Nix shell heuristic
        format = "[   ](fg:bright-blue bold)";  # Nix shell format
        impure_msg = "";  # Impure message
        pure_msg = "";  # Pure message
        unknown_msg = "";  # Unknown message
      };
    };
  };
}
# SIXEL SUPPORT:
# - Display images in terminal
# - Use with img2sixel or chafa
# - Example: img2sixel image.png
#
# SHORTCUTS (Foot):
# - Ctrl+Shift+C: Copy
# - Ctrl+Shift+V: Paste
# - Ctrl+Shift+U: Unicode input
# - Ctrl+Shift+N: New window
# - Shift+PageUp/Down: Scroll
#
# ZELLIJ SHORTCUTS:
# - Ctrl+t: New tab
# - Ctrl+p: New pane
# - Ctrl+n: Switch panes
# - Ctrl+q: Quit
# - More: https://zellij.dev/documentation/
