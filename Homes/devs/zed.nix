# /etc/nixos/SpidyNix/Homes/devs/zed.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # ZED EDITOR CONFIGURATION
  # ============================================================================
  # ZED SETTINGS
  # ==========================================================================
  # Configuration for Zed editor
  # ==========================================================================
  programs.zed-editor = {
    enable = true;  # Enable Zed configuration

    # Settings for Zed editor
    # The key has been changed from 'settings' to 'userSettings'
    userSettings = {
      # Editor settings
      # Zed's settings.json typically uses kebab-case for keys.
      # If you encounter issues, you may need to adjust key names
      # to match Zed's expected format (e.g., font_size instead of fontSize).
      # The dotted notation "editor.fontSize" might be interpreted literally
      # as a key, or you might need a nested structure:
      "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";
      "editor.fontSize" = 14;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;

      # Theme settings
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.iconTheme" = "material-icon-theme";

      # Language server settings
      "lsp.enable" = true;
      "lsp.servers" = {
        #typescript = "${pkgs.typescript-language-server}/bin/typescript-language-server";
        #html = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
        #css = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
        #json = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
        #vue = "${pkgs.vue-language-server}/bin/vue-language-server";
        #astro = "${pkgs.astro-language-server}/bin/astro-language-server";
        nix = "${pkgs.nixd}/bin/nixd";
      };

      # Biome settings
      #"biome.enable" = true;
      #"biome.path" = "${pkgs.biome}/bin/biome";
    };
  };

}
