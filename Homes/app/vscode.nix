{ config, pkgs, ... }:

# ============================================================================
# SPIDYNIX VSCODE CONFIGURATION
# ============================================================================
# VSCode setup with Nix, Rust, Python support and telemetry disabled
# Optimized for development workflow
# ============================================================================

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    # =========================================================================
    # EXTENSIONS
    # =========================================================================
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Nix language support
      bbenoist.nix
      jnoortheen.nix-ide

      # Language support
      ms-vscode.cpptools
      rust-lang.rust-analyzer
      ms-python.python
      tamasfe.even-better-toml
      yzhang.markdown-all-in-one

      # Tools and utilities
      vscodevim.vim
      eamodio.gitlens
      rooveterinaryinc.roo-cline
      kilocode.kilo-code
      continue.continue
    ];

    # =========================================================================
    # USER SETTINGS
    # =========================================================================
    profiles.default.userSettings = {
      # ...editor settings...
      "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.bracketPairColorization.enabled" = true;
      "editor.minimap.enabled" = true;
      "editor.renderWhitespace" = "boundary";
      "editor.rulers" = [ 80 120 ];

      # Terminal settings
      "terminal.integrated.fontFamily" = "'JetBrains Mono', monospace";
      "terminal.integrated.fontSize" = 13;
      "terminal.integrated.defaultProfile.linux" = "Nushell";
      "terminal.integrated.profiles.linux.Nushell.path" = "${pkgs.nushell}/bin/nu";

      # File settings
      "files.autoSave" = "onFocusChange";
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;

      # Theme settings
      "workbench.colorTheme" = "Default Dark+";
      "workbench.iconTheme" = "vs-seti";

      # Nix IDE settings
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
        };
      };

      # Git settings
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;

      # Vim settings
      "vim.useSystemClipboard" = true;

      # ===================================================================
      # TELEMETRY DISABLED
      # ===================================================================
      "telemetry.telemetryLevel" = "off";
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;
      "extensions.telemetry" = false;
      "workbench.enableExperiments" = false;
      "workbench.settings.enableNaturalLanguageSearch" = false;
    };
  };
}
