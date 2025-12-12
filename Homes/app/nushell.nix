{ config, pkgs, lib, inputs, ... }:

{
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;

    plugins = with pkgs.nushellPlugins; [ query gstat polars ];
    
    shellAliases = {
      cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
      listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixremove = "nix-store --gc";
      bloat = "nix path-info -Sh /run/current-system";
      test-build = "nh os test";
      switch-build = "nh os switch";
      c = "clear";
      q = "exit";
      cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
      trimall = "sudo fstrim -va";
      temp = "cd /tmp/";
      zed = "zeditor";
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
      cat = "bat --number --color=always --paging=never --tabs=2 --wrap=never";
      grep = "rg";
      l = "eza -lF --time-style=long-iso --icons";
      ll = "eza -lh --git --icons --color=auto --group-directories-first -s extension";
      tree = "eza --tree --icons";
      ls = "eza --icons";
      us = "systemctl --user";
      rs = "sudo systemctl";
      copy = "wl-copy";
      paste = "wl-paste";
    };

    environmentVariables = {
      PROMPT_INDICATOR_VI_INSERT = "  ";
      PROMPT_INDICATOR_VI_NORMAL = "∙ ";
      PROMPT_COMMAND = "";
      PROMPT_COMMAND_RIGHT = "";
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      SHELL = "${pkgs.nushell}/bin/nu";
      EDITOR = "hx";
      VISUAL = "hx";
      CARAPACE_BRIDGES = "inshellisense,carapace,zsh,fish,bash";
    };

    extraEnv = ''
      $env.CARAPACE_BRIDGES = 'inshellisense,carapace,zsh,fish,bash'
    '';

    extraConfig = let
      conf = builtins.toJSON {
        show_banner = false;
        edit_mode = "vi";
        buffer_editor = "hx";

        completions = {
          algorithm = "substring";
          sort = "smart";
          case_sensitive = false;
          quick = true;
          partial = true;
          use_ls_colors = true;
        };

        shell_integration = {
          osc2 = true;
          osc7 = true;
          osc8 = true;
        };

        use_kitty_protocol = true;
        bracketed_paste = true;
        use_ansi_coloring = true;
        error_style = "fancy";

        display_errors = {
          exit_code = false;
          termination_signal = true;
        };

        table = {
          mode = "single";
          index_mode = "always";
          show_empty = true;
          padding = { left = 1; right = 1; };
          trim = {
            methodology = "wrapping";
            wrapping_try_keep_words = true;
            truncating_suffix = "...";
          };
          header_on_separator = true;
          abbreviated_row_count = null;
          footer_inheritance = true;
        };

        ls = { use_ls_colors = true; };
        rm = { always_trash = false; };

        # === FIXED: Keybindings are defined here, not with 'bind' ===
        keybindings = [
          # Ctrl+C to Interrupt
          {
            name = "unix_line_discard_on_ctrl_c";
            modifier = "control";
            keycode = "c";
            mode = [ "vi_normal" "vi_insert" ];
            event = { send = "CtrlC"; };
          }
          # Ctrl+V to Paste
          {
            name = "paste_on_ctrl_v";
            modifier = "control";
            keycode = "v";
            mode = [ "vi_normal" "vi_insert" ];
            event = { send = "Paste"; };
          }
          # Note: 'Copy' in normal mode (Ctrl+C) is usually handled by 
          # your terminal emulator (e.g., Alacritty/Kitty), not the shell.
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
              match_text = { attr = "u"; };
              selected_match_text = { attr = "ur"; };
              description_text = "yellow";
            };
          }
        ];

        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };

        highlight_resolved_externals = true;
      };

      completionScripts = builtins.concatStringsSep "\n" (
        map (name: "source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/${name}/${name}-completions.nu")
        ["git" "nix" "man" "rg" "gh" "glow" "bat"]
      );
    in ''
      # Nushell configuration
      $env.config = ${conf};

      # Load completion scripts
      ${completionScripts}

      # ===================================================================
      # CUSTOM FUNCTIONS
      # ===================================================================
      
      # Custom function: Fuzzy directory change
      def --env fcd [] {
        let selected = (fd --type d --strip-cwd-prefix | sk --ansi)
        if not ($selected | is-empty) { cd $selected }
      }

      # Custom function: List installed packages
      def installed [] {
        nix-store --query --requisites /run/current-system/ | parse --regex '.*?-(.*)' | get capture0 | sk
      }

      # Custom function: Copy all installed packages
      def installedall [] {
        nix-store --query --requisites /run/current-system/ | sk | wl-copy
      }

      # Custom function: Yazi file manager with cd integration
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