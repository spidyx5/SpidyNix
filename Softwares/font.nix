# /etc/nixos/SpidyNix/Softwares/font.nix
{ config, pkgs, lib, ... }:
{
  fonts.packages = with pkgs; [
    # --- Core Fonts ---
    noto-fonts                    # Google Noto fonts (extensive language support)
    noto-fonts-cjk-sans           # Chinese, Japanese, Korean
    noto-fonts-color-emoji        # Color emoji support

    # --- System Fonts ---
    dejavu_fonts                  # DejaVu font family
    liberation_ttf                # Liberation fonts (Microsoft font alternatives)
    adwaita-fonts                 # GNOME system font

    # --- Monospace Fonts (Programming) ---
    fira-code                     # Fira Code with ligatures
    fira-code-symbols             # Fira Code symbols
    jetbrains-mono                # JetBrains Mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.symbols-only       # Vital for Glyphs/Icons in Waybar/Terminal
    nerd-fonts.zed-mono

    # --- Special Purpose Fonts ---
    font-awesome                  # Font Awesome icons
    material-symbols              # Material Design symbols
    material-icons                # Material Design icons
    terminus_font                 # Terminus bitmap font

    # --- Additional Fonts ---
    inter                         # Inter font family
  ];

  # ============================================================================
  # FONT CONFIGURATION
  # ============================================================================
  # Font rendering and default font selection
  # ============================================================================
  fonts.fontconfig = {
    enable = true;

    # --- Antialiasing ---
    antialias = true;

    # --- Hinting ---
    hinting = {
      enable = true;
      autohint = false;
      style = "full";             # Options: none, slight, medium, full
    };

    # --- Subpixel Rendering ---
    subpixel = {
      lcdfilter = "default";      # LCD filter for subpixel rendering
      rgba = "rgb";               # Subpixel layout: rgb, bgr, vrgb, vbgr
    };

    # --- Default Fonts ---
    defaultFonts = {
      serif = [
        "Noto Serif"
        "DejaVu Serif"
        "Liberation Serif"
      ];

      sansSerif = [
        "Adwaita Sans"
        "Noto Sans"
        "DejaVu Sans"
        "Liberation Sans"
      ];

      monospace = [
        "GeistMono Nerd Font Mono"
        "JetBrainsMono Nerd Font Mono"
        "FiraCode Nerd Font Mono"
        "Fira Code"
        "JetBrains Mono"
      ];

      emoji = [
        "Noto Color Emoji"
      ];
    };

    # --- Local Configuration ---
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        <!-- Emoji font preferences -->
        <alias>
          <family>emoji</family>
          <prefer>
            <family>Noto Color Emoji</family>
          </prefer>
        </alias>

        <!-- Symbol font preferences -->
        <alias>
          <family>monospace</family>
          <prefer>
            <family>Symbols Nerd Font</family>
          </prefer>
        </alias>
      </fontconfig>
    '';
  };

  fonts.fontDir = {
    enable = true;
    decompressFonts = true;
  };

  # DISABLE DEFAULT PACKAGES
  # Disable default font packages to have full control
  fonts.enableDefaultPackages = false;
}
