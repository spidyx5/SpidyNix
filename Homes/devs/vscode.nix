# /etc/nixos/SpidyNix/Homes/devs/vscode.nix
{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;  # Enable VSCode configuration
    package = pkgs.vscodium;  # Use VSCodium (open-source VSCode)

    # ==========================================================================
    # EXTENSIONS
    # ==========================================================================
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix language support
      bbenoist.nix  # Nix language support with syntax highlighting
      jnoortheen.nix-ide  # Nix IDE with language server support

      # Language support
      ms-vscode.cpptools  # C/C++ language support with IntelliSense
      rust-lang.rust-analyzer  # Rust language support with Rust Analyzer
      ms-python.python  # Python language support with IntelliSense
      tamasfe.even-better-toml  # Enhanced TOML language support
      yzhang.markdown-all-in-one  # Markdown editing support

      # Tools and utilities
      vscodevim.vim  # Vim keybindings for VSCode
      eamodio.gitlens  # Git supercharged - visualizations and navigation
      rooveterinaryinc.roo-cline  # CLI tool integration
      kilocode.kilo-code  # Code metrics and analytics
      continue.continue  # AI-powered code completion
    ];

    # ==========================================================================
    # USER SETTINGS (settings.json)
    # ==========================================================================
    profiles.default.userSettings = {
      # Editor settings
      "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";  # Font family
      "editor.fontSize" = 14;  # Font size
      "editor.fontLigatures" = true;  # Enable font ligatures
      "editor.tabSize" = 2;  # Tab size
      "editor.formatOnSave" = true;  # Format on save
      "editor.bracketPairColorization.enabled" = true;  # Bracket pair colorization
      "editor.minimap.enabled" = true;  # Enable minimap
      "editor.renderWhitespace" = "boundary";  # Render whitespace
      "editor.rulers" = [ 80 120 ];  # Column rulers

      # Terminal settings (Uses Nushell)
      "terminal.integrated.fontFamily" = "'JetBrains Mono', monospace";  # Terminal font
      "terminal.integrated.fontSize" = 13;  # Terminal font size
      "terminal.integrated.defaultProfile.linux" = "Nushell";  # Default terminal
      "terminal.integrated.profiles.linux.Nushell.path" = "${pkgs.nushell}/bin/nu";  # Nushell path

      # File settings
      "files.autoSave" = "onFocusChange";  # Auto-save on focus change
      "files.trimTrailingWhitespace" = true;  # Trim trailing whitespace
      "files.insertFinalNewline" = true;  # Insert final newline

      # Theme settings
      "workbench.colorTheme" = "Default Dark+";  # Color theme
      "workbench.iconTheme" = "vs-seti";  # Icon theme

      # Nix IDE settings
      "nix.enableLanguageServer" = true;  # Enable Nix language server
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";  # Use nixd (faster)
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = { "command" = [ "nixpkgs-fmt" ]; };  # Formatting command
        };
      };

      # Git settings
      "git.enableSmartCommit" = true;  # Enable smart commit
      "git.confirmSync" = false;  # Disable sync confirmation

      # Vim settings
      "vim.useSystemClipboard" = true;  # Use system clipboard
    };
  };
}
# ============================================================================
# VSCODE CONFIGURATION
# ============================================================================
# Configures Visual Studio Code, Extensions, and User Settings.
# ============================================================================
# NOTES:
# - This configuration sets up VSCodium with essential extensions
# - Uses JetBrains Mono font with ligatures
# - Nushell is configured as the default terminal
# - Nix language support is enabled with nixd
# - For troubleshooting:
#   - Check VSCodium installation: which codium
#   - Verify extensions: codium --list-extensions
#   - Check settings: codium --status
# - To customize:
#   - Add/remove extensions as needed
#   - Change font settings to match your preferences
#   - Adjust terminal settings for different shells
#   - Modify Nix language server settings
# ============================================================================
