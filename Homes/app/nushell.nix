{ config, pkgs, lib, ... }:

{
  # ========================================================================
  # CARAPACE (Completions)
  # ========================================================================
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  # ========================================================================
  # NUSHELL CONFIGURATION
  # ========================================================================
  programs.nushell = {
    enable = true;

    # Plugins (Only include if you actually use them to save startup time)
    plugins = with pkgs.nushellPlugins; [ query gstat polars ];

    # ----------------------------------------------------------------------
    # ALIASES
    # ----------------------------------------------------------------------
    shellAliases = {
      # System
      c = "clear";
      q = "exit";
      cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
      listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixremove = "nix-store --gc";
      bloat = "nix path-info -Sh /run/current-system";
      test-build = "nh os test";
      switch-build = "nh os switch";
      cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
      trimall = "sudo fstrim -va";
      temp = "cd /tmp/";
      us = "systemctl --user";
      rs = "sudo systemctl";

      # Editors
      zed = "zeditor";

      # Git
      lg = "lazygit";
      g = "git";
      add = "git add .";
      commit = "git commit";
      push = "git push";
      pull = "git pull";
      diff = "git diff --staged";
      gcld = "git clone --depth 1";
      gco = "git checkout";
      gitgrep = "git ls-files | rg";

      # Modern Replacements
      cat = "bat --number --color=always --paging=never --tabs=2 --wrap=never";
      grep = "rg";
      l = "eza -lF --time-style=long-iso --icons";
      ll = "eza -lh --git --icons --color=auto --group-directories-first -s extension";
      tree = "eza --tree --icons";
      ls = "eza --icons";
      copy = "wl-copy";
      paste = "wl-paste";
    };

    # ----------------------------------------------------------------------
    # ENVIRONMENT VARIABLES
    # ----------------------------------------------------------------------
    environmentVariables = {
      PROMPT_INDICATOR_VI_INSERT = "': '";
      PROMPT_INDICATOR_VI_NORMAL = "'∙ '";
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      SHELL = "${pkgs.nushell}/bin/nu";
      EDITOR = "hx";
      VISUAL = "hx";
      # Tell Carapace which bridges to enable
      CARAPACE_BRIDGES = "'inshellisense,zsh,fish,bash'";
    };

    # ----------------------------------------------------------------------
    # MAIN CONFIGURATION (Replaces your old toJSON block)
    # ----------------------------------------------------------------------
    settings = {
      show_banner = false;
      edit_mode = "vi";
      buffer_editor = "hx";

      completions = {
        algorithm = "substring";
        sort = "smart";
        case_sensitive = false;
        quick = true;
        partial = true;
      };

      shell_integration = {
        osc2 = true;
        osc7 = true;
        osc8 = true;
      };

      table = {
        mode = "rounded";
        index_mode = "always";
        show_empty = true;
        padding = { left = 1; right = 1; };
        trim = {
          methodology = "wrapping";
          wrapping_try_keep_words = true;
          truncating_suffix = "...";
        };
        header_on_separator = true;
      };

      ls = { use_ls_colors = true; };
      rm = { always_trash = false; };

      cursor_shape = {
        vi_insert = "line";
        vi_normal = "block";
      };

      # Keybindings
      keybindings = [
        {
          name = "unix_line_discard_on_ctrl_c";
          modifier = "control";
          keycode = "c";
          mode = [ "vi_normal" "vi_insert" ];
          event = { send = "CtrlC"; };
        }
        {
          name = "paste_on_ctrl_v";
          modifier = "control";
          keycode = "v";
          mode = [ "vi_normal" "vi_insert" ];
          event = { send = "Paste"; };
        }
      ];

      menus = [
        {
          name = "completion_menu";
          only_buffer_difference = false;
          marker = "? ";
          type = {
            layout = "ide";
            min_completion_width = 0;
            max_completion_width = 150;
            max_completion_height = 25;
            padding = 0;
            border = false;
            cursor_offset = 0;
            description_mode = "prefer_right";
            min_description_width = 0;
            max_description_width = 50;
            max_description_height = 10;
            description_offset = 1;
            correct_cursor_pos = true;
          };
          style = {
            text = "white";
            selected_text = "white_reverse";
            description_text = "yellow";
          };
        }
      ];
    };

    # ----------------------------------------------------------------------
    # CUSTOM FUNCTIONS (Extra Config)
    # ----------------------------------------------------------------------
    extraConfig = ''
      # Fuzzy directory change with 'sk' (skim)
      def --env fcd [] {
        let selected = (fd --type d --strip-cwd-prefix | sk --ansi)
        if not ($selected | is-empty) { cd $selected }
      }

      # List installed packages with 'sk'
      def installed [] {
        nix-store --query --requisites /run/current-system/ | parse --regex '.*?-(.*)' | get capture0 | sk
      }

      # Copy all installed packages
      def installedall [] {
        nix-store --query --requisites /run/current-system/ | sk | wl-copy
      }

      # Yazi file manager with cd integration
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
