# /etc/nixos/SpidyNix/Homes/devs/nushell.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # CARAPACE - MULTI-SHELL COMPLETION
  # ============================================================================
  # Carapace provides completions for multiple shells
  # ============================================================================
  programs.carapace = {
    enable = true;  # Enable Carapace
    enableNushellIntegration = true;  # Enable Nushell integration
  };

  # ============================================================================
  # NUSHELL - MODERN SHELL
  # ============================================================================
  # Nushell with structured data and modern features
  # ============================================================================
  programs.nushell = {
    enable = true;  # Enable Nushell

    # --- Plugins ---
    plugins = with pkgs.nushellPlugins; [
      query  # Query plugin
      gstat  # Git statistics plugin
      polars  # Polars plugin
    ];

    # --- Shell Aliases ---
    shellAliases = {
      # Nix system management
      cleanup = "sudo nix-collect-garbage --delete-older-than 1d";  # Cleanup Nix garbage
      listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";  # List Nix generations
      nixremove = "nix-store --gc";  # Remove Nix store garbage
      bloat = "nix path-info -Sh /run/current-system";  # Show Nix bloat

      # NixOS rebuild shortcuts
      test-build = "nh os test";  # Test NixOS rebuild
      switch-build = "nh os switch";  # Switch NixOS rebuild

      # System utilities
      c = "clear";  # Clear terminal
      q = "exit";  # Exit shell
      cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";  # Clean RAM
      trimall = "sudo fstrim -va";  # Trim all
      temp = "cd /tmp/";  # Go to temp directory

      # Application shortcuts
      zed = "zeditor";  # Launch Zed editor
      lg = "lazygit";  # Launch Lazygit

      # Git shortcuts
      g = "git";  # Git
      add = "git add .";  # Git add
      commit = "git commit";  # Git commit
      push = "git push";  # Git push
      pull = "git pull";  # Git pull
      diff = "git diff --staged";  # Git diff
      gcld = "git clone --depth 1";  # Git clone with depth 1
      gco = "git checkout";  # Git checkout
      gitgrep = "git ls-files | rg";  # Git grep

      # Modern CLI tools
      cat = "bat --number --color=always --paging=never --tabs=2 --wrap=never";  # Bat with options
      grep = "rg";  # Ripgrep
      l = "eza -lF --time-style=long-iso --icons";  # Eza with options
      ll = "eza -lh --git --icons --color=auto --group-directories-first -s extension";  # Eza with options
      tree = "eza --tree --icons";  # Eza tree
      ls = "eza --icons";  # Eza with icons

      # Systemctl shortcuts
      us = "systemctl --user";  # Systemctl user
      rs = "sudo systemctl";  # Systemctl root
    };

    # --- Environment Variables ---
    environmentVariables = {
      PROMPT_INDICATOR_VI_INSERT = "  ";  # Vi insert mode indicator
      PROMPT_INDICATOR_VI_NORMAL = "∙ ";  # Vi normal mode indicator
      PROMPT_COMMAND = "";  # Prompt command
      PROMPT_COMMAND_RIGHT = "";  # Prompt command right
      NIXPKGS_ALLOW_UNFREE = "1";  # Allow unfree packages
      NIXPKGS_ALLOW_INSECURE = "1";  # Allow insecure packages
      SHELL = "${pkgs.nushell}/bin/nu";  # Set shell to Nushell
      EDITOR = "hx";  # Set editor to Helix
      VISUAL = "hx";  # Set visual editor to Helix
      CARAPACE_BRIDGES = "inshellisense,carapace,zsh,fish,bash";  # Carapace bridges
    };

    # --- Extra Environment Setup ---
    extraEnv = ''
      $env.CARAPACE_BRIDGES = 'inshellisense,carapace,zsh,fish,bash'  # Carapace bridges
    '';

    # --- Nushell Configuration ---
    extraConfig = let
      # Nushell config as Nix attrset, converted to JSON
      conf = builtins.toJSON {
        show_banner = false;  # Disable banner
        edit_mode = "vi";  # Vi mode
        buffer_editor = "hx";  # Buffer editor

        completions = {
          algorithm = "substring";  # Completion algorithm
          sort = "smart";  # Completion sort
          case_sensitive = false;  # Case sensitive
          quick = true;  # Quick completion
          partial = true;  # Partial completion
          use_ls_colors = true;  # Use ls colors
        };

        shell_integration = {
          osc2 = true;  # OSC 2
          osc7 = true;  # OSC 7
          osc8 = true;  # OSC 8
        };

        use_kitty_protocol = true;  # Use Kitty protocol
        bracketed_paste = true;  # Bracketed paste
        use_ansi_coloring = true;  # Use ANSI coloring
        error_style = "fancy";  # Error style

        display_errors = {
          exit_code = false;  # Display exit code
          termination_signal = true;  # Display termination signal
        };

        table = {
          mode = "single";  # Table mode
          index_mode = "always";  # Index mode
          show_empty = true;  # Show empty
          padding = {
            left = 1;  # Left padding
            right = 1;  # Right padding
          };
          trim = {
            methodology = "wrapping";  # Trim methodology
            wrapping_try_keep_words = true;  # Wrapping try keep words
            truncating_suffix = "...";  # Truncating suffix
          };
          header_on_separator = true;  # Header on separator
          abbreviated_row_count = null;  # Abbreviated row count
          footer_inheritance = true;  # Footer inheritance
        };

        ls = {
          use_ls_colors = true;  # Use ls colors
        };

        rm = {
          always_trash = false;  # Always trash
        };

        menus = [
          {
            name = "completion_menu";  # Completion menu
            only_buffer_difference = false;  # Only buffer difference
            marker = "? ";  # Marker
            type = {
              layout = "ide";  # Layout
              min_completion_width = 0;  # Min completion width
              max_completion_width = 150;  # Max completion width
              max_completion_height = 25;  # Max completion height
              padding = 0;  # Padding
              border = false;  # Border
              cursor_offset = 0;  # Cursor offset
              description_mode = "prefer_right";  # Description mode
              min_description_width = 0;  # Min description width
              max_description_width = 50;  # Max description width
              max_description_height = 10;  # Max description height
              description_offset = 1;  # Description offset
              correct_cursor_pos = true;  # Correct cursor position
            };
            style = {
              text = "white";  # Text color
              selected_text = "white_reverse";  # Selected text color
              match_text = { attr = "u"; };  # Match text
              selected_match_text = { attr = "ur"; };  # Selected match text
              description_text = "yellow";  # Description text color
            };
          }
        ];

        cursor_shape = {
          vi_insert = "line";  # Vi insert cursor shape
          vi_normal = "block";  # Vi normal cursor shape
        };

        highlight_resolved_externals = true;  # Highlight resolved externals
      };

      # Completion scripts helper function
      completions = let
        completion = name: ''
          source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu
        '';
      in
        names:
          builtins.foldl'
          (prev: str: "${prev}\n${str}") ""
          (map completion names);
    in ''
      # Set Nushell configuration
      $env.config = ${conf};

      # Load completion scripts
      ${completions ["git" "nix" "man" "rg" "gh" "glow" "bat"]}

      # Custom function: Change directory with fuzzy search
      def --env fcd [] {
        let selected = (fd --type d --strip-cwd-prefix | sk --ansi)
        if not ($selected | is-empty) { cd $selected }
      }

      # Custom function: List installed packages
      def installed [] {
        nix-store --query --requisites /run/current-system/ | parse --regex '.*?-(.*)' | get capture0 | sk
      }

      # Custom function: List all installed packages with full paths
      def installedall [] {
        nix-store --query --requisites /run/current-system/ | sk | wl-copy
      }

      # Custom function: Yazi file manager with directory change
      def --env fm [...args] {
        let tmp = (mktemp -t "yazi-cwd.XXXXX")
        yazi ...$args --cwd-file $tmp
        let cwd = (open $tmp)
        if $cwd != "" and $cwd != $env.PWD {
          cd $cwd
        }
        rm -fp $tmp
      }
    '';
  };
}
# ============================================================================
# NUSHELL CONFIGURATION
# ============================================================================
# This file configures Nushell (modern shell with structured data)
# Home Manager module for user 'spidy'
# ============================================================================
# ============================================================================
# NOTES
# ============================================================================
# NUSHELL:
# - Modern shell with structured data (tables, records, lists)
# - Built-in commands for data manipulation
# - Cross-platform (Windows, macOS, Linux)
# - Vi mode enabled for vim-like editing
# - Helix as default editor
#
# VI MODE:
# - Normal mode: ESC or Ctrl+[
# - Insert mode: i, a, etc.
# - Cursor changes shape (line in insert, block in normal)
#
# CUSTOM FUNCTIONS:
# - fcd: Fuzzy directory change (uses fd and sk)
# - installed: Browse installed packages
# - installedall: Copy all installed package paths
# - fm: Yazi file manager with cd integration
#
# PLUGINS:
# - query: Query data with jq-like syntax
# - gstat: Git statistics
# - polars: DataFrame operations
#
# COMPLETIONS:
# - Carapace: Universal completion engine
# - Nu scripts: Custom completions for common tools
# - IDE-style completion menu
#
# SHELL INTEGRATION:
# - OSC codes for terminal integration
# - Kitty protocol support
# - Automatic title updates
#
# ALIASES:
# - Modern CLI alternatives (eza, bat, rg, fd)
# - Git shortcuts
# - System management
# - NixOS rebuild shortcuts
#
# DATA MANIPULATION:
# - Pipe data through commands
# - Filter, sort, group, select
# - Convert between formats (JSON, YAML, TOML, CSV)
# - Example: ls | where size > 1mb | sort-by modified
#
# ENVIRONMENT:
# - Variables in $env scope
# - CARAPACE_BRIDGES for multi-shell completions
# - EDITOR set to helix
#
# CONFIGURATION:
# - Config in this file (extraConfig)
# - Additional config: ~/.config/nushell/config.nu
# - Environment: ~/.config/nushell/env.nu
#
# LEARNING NUSHELL:
# - Built-in help: help commands
# - Command help: help COMMAND
# - Tutorial: https://www.nushell.sh/book/
# - Try: enter { ... } to test commands
#
# TROUBLESHOOTING:
# - Error messages show in fancy style
# - Check config: $env.config
# - Reload config: source ~/.config/nushell/config.nu
# - Check path: $env.PATH
# ============================================================================
