{ config, pkgs, lib, inputs, ... }:

# ============================================================================
# SPIDYNIX ZED EDITOR CONFIGURATION
# ============================================================================
# Modern code editor with LSP, Nix, and Biome formatter support
# ============================================================================

{
  programs.zed-editor = {
    enable = true;

    userSettings = {
      # ===================================================================
      # EDITOR SETTINGS
      # ===================================================================
      "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";
      "editor.fontSize" = 14;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.lineNumbers" = "relative";
      "editor.showWhitespace" = "boundary";

      # ===================================================================
      # THEME SETTINGS
      # ===================================================================
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.iconTheme" = "material-icon-theme";

      # ===================================================================
      # LANGUAGE SERVER SETTINGS
      # ===================================================================
      "lsp.enable" = true;
      "lsp.servers" = {
        nix = "${pkgs.nixd}/bin/nixd";
      };

      # ===================================================================
      # BIOME FORMATTER & LINTER
      # ===================================================================
      # Biome is a fast formatter/linter for JS/TS/JSX/JSON
      # Better alternative to Prettier + ESLint combined
      "biome.enable" = true;
      "biome.path" = "${pkgs.biome}/bin/biome";
    };
  };
}
