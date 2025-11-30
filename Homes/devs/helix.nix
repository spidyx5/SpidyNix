# /etc/nixos/SpidyNix/Homes/devs/helix.nix
{ config, pkgs, lib, ... }:

 {
  # ============================================================================
  # HELIX CONFIGURATION
  # ============================================================================
  # Configure Helix editor with custom theme, keybindings, and settings
  # ============================================================================

  programs.helix = {
    enable = true;  # Enable Helix

    settings = {
      # Theme
      theme = "carbon";  # Set theme to carbon

      # Editor configuration
      editor = {
        color-modes = true;  # Enable color modes
        completion-trigger-len = 1;  # Completion trigger length
        completion-replace = true;  # Replace completion
        cursorline = true;  # Highlight current line
        bufferline = "multiple";  # Multiple buffer lines
        line-number = "relative";  # Relative line numbers

        cursor-shape = {
          insert = "bar";  # Bar cursor in insert mode
          normal = "block";  # Block cursor in normal mode
          select = "underline";  # Underline cursor in select mode
        };

        undercurl = true;  # Enable undercurl
        true-color = true;  # Enable true color

        soft-wrap.enable = true;  # Enable soft wrap

        indent-guides = {
          render = true;  # Render indent guides
          rainbow-option = "dim";  # Rainbow indent guides
        };

        inline-diagnostics = {
          cursor-line = "hint";  # Show hints on cursor line
          other-lines = "error";  # Show errors on other lines
          max-diagnostics = 3;  # Maximum diagnostics
        };

        lsp = {
          display-messages = true;  # Display LSP messages
          display-inlay-hints = true;  # Display inlay hints
        };

        gutters = ["diagnostics" "line-numbers" "spacer" "diff"];  # Gutters

        statusline = {
          left = ["mode" "spacer" "version-control"];  # Left status line
          center = ["file-modification-indicator" "file-name" "spinner"];  # Center status line
          right = ["diagnostics" "selections" "position" "position-percentage" "total-line-numbers"];  # Right status line
          mode = {
            normal = "NORMAL";  # Normal mode
            insert = "INSERT";  # Insert mode
            select = "SELECT";  # Select mode
          };
        };

        trim-final-newlines = true;  # Trim final newlines
        trim-trailing-whitespace = true;  # Trim trailing whitespace

        whitespace = {
          render = {
            space = "all";  # Render all spaces
            tab = "all";  # Render all tabs
            newline = "all";  # Render all newlines
          };
          characters = {
            space = " ";  # Space character
            nbsp = "⍽";  # Non-breaking space character
            tab = "→";  # Tab character
            newline = "↴";  # Newline character
            tabpad = "-";  # Tab padding character
          };
        };

        auto-pairs = true;  # Enable auto pairs
        clipboard-provider = "wayland";  # Use Wayland clipboard
      };

      # Insert mode keybindings
      keys.insert = {
        C-h = "move_char_left";  # Move left
        C-j = "move_line_down";  # Move down
        C-k = "move_line_up";  # Move up
        C-l = "move_char_right";  # Move right
        C-e = "goto_line_end";  # Go to line end
        C-b = "goto_line_start";  # Go to line start
      };

      # Normal mode keybindings
      keys.normal = {
        # Move lines up/down
        A-j = ["extend_to_line_bounds" "delete_selection" "paste_after"];  # Move line down
        A-k = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];  # Move line up
        A-h = ["delete_selection" "move_char_left" "paste_before"];  # Move left
        A-l = ["delete_selection" "move_char_right" "paste_after"];  # Move right

        # Jump between splits
        C-h = ["jump_view_left"];  # Jump left
        C-j = ["jump_view_down"];  # Jump down
        C-k = ["jump_view_up"];  # Jump up
        C-l = ["jump_view_right"];  # Jump right

        # Buffer navigation
        tab = ["goto_next_buffer"];  # Next buffer
        S-tab = ["goto_previous_buffer"];  # Previous buffer

        # Buffer management
        space = {
          x = ":buffer-close";  # Close buffer
        };

        # Utility commands
        space.u = {
          f = ":format";  # Format
          w = ":set whitespace.render all";  # Show whitespace
          W = ":set whitespace.render none";  # Hide whitespace
        };
      };
    };
  };
}
# ============================================================================
# HELIX EDITOR CONFIGURATION
# ============================================================================
# This file configures Helix editor for user 'spidy'.
# Helix is a modern, modal text editor with built-in LSP support.
#
# Home Manager module for Helix configuration.
# ============================================================================
# NOTES
# ============================================================================
# USAGE:
# - Launch: hx or helix
# - Open file: hx filename.txt
# - Open directory: hx .
#
# MODES:
# - Normal mode: Default mode, press Esc
# - Insert mode: Press 'i'
# - Select mode: Press 'v'
#
# KEY BINDINGS (Custom):
# Insert mode:
# - Ctrl+h/j/k/l: Move cursor
# - Ctrl+e: End of line
# - Ctrl+b: Beginning of line
#
# Normal mode:
# - Tab/Shift+Tab: Next/previous buffer
# - Space+x: Close buffer
# - Space+u+f: Format document
# - Space+u+w: Show whitespace
# - Alt+j/k: Move lines up/down
# - Ctrl+h/j/k/l: Jump between splits
#
# LSP:
# - gd: Go to definition
# - gr: Go to references
# - Space+k: Show hover documentation
# - Space+r: Rename symbol
# - Space+a: Code actions
#
# FILE OPERATIONS:
# - :w - Save
# - :q - Quit
# - :wq - Save and quit
# - :q! - Quit without saving
#
# SEARCHING:
# - / - Search forward
# - ? - Search backward
# - n - Next match
# - N - Previous match
#
# CONFIGURATION:
# - Config file: ~/.config/helix/config.toml
# - Languages: ~/.config/helix/languages.toml
# - Themes: ~/.config/helix/themes/
#
# LEARNING:
# - :tutor - Interactive tutorial
# - :help - Help documentation
# ============================================================================
