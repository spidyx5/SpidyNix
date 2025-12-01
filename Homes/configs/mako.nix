# /etc/nixos/SpidyNix/Homes/configs/mako.nix
{ pkgs, ... }:

{
  # Install Mako package
  home.packages = with pkgs; [
    mako  # Notification daemon
  ];

  # Enable Mako notifications daemon
  services.mako = {
    enable = true;  # Enable Mako
    settings = {
      # Appearance
      font = "ZedMono Nerd Font 10";  # Font to use
      backgroundColor = "#1a1b26";  # TokyoNight background color
      borderColor = "#7aa2f7";  # Border color
      textColor = "#c0caf5";  # Text color
      borderRadius = 8;  # Border radius
      borderSize = 2;  # Border size

      # Behavior
      defaultTimeout = 5000;  # Default timeout (5 seconds)
      layer = "overlay";  # Layer to use
      anchor = "top-right";  # Anchor position

      # Grouping
      max-Visible = 5;  # Maximum visible notifications
      sort = "-time";  # Sort by time
    };
  };
}

