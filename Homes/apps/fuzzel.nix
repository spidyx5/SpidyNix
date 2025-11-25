# /etc/nixos/SpidyNix/Homes/apps/fuzzel.nix
{ pkgs, ... }:
{
  # Install Fuzzel package
  home.packages = with pkgs; [
    fuzzel  # Application launcher
  ];

  # Fuzzel configuration
  programs.fuzzel = {
    enable = true;  # Enable Fuzzel
    settings = {
      main = {
        # Terminal to use
        terminal = "${pkgs.kitty}/bin/kitty";
        # Layer to use
        layer = "overlay";
        # Width of the window
        width = 60;
        # Font to use
        font = "ZedMono Nerd Font:size=14";
        # Icon theme to use
        icon-theme = "Papirus-Dark";
      };
      colors = {
        # TokyoNight color scheme
        background = "1a1b26dd";  # TokyoNight BG transparent
        text = "c0caf5ff";  # TokyoNight FG
        match = "f7768eff";  # Red match
        selection = "7aa2f7ff";  # Blue selection
        selection-text = "1a1b26ff";  # Selection text color
        border = "7aa2f7ff";  # Border color
      };
      border = {
        # Border width
        width = 2;
        # Border radius
        radius = 10;
      };
    };
  };
}
# Notes
#
