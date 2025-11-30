# /etc/nixos/SpidyNix/Homes/home.nix
{ config, pkgs, lib, inputs, userConfig, ... }:

{
  # ============================================================================
  # IMPORTS
  # ============================================================================
  imports = [
    # Window Managers
    inputs.niri.homeModules.niri
    inputs.dms.homeModules.dankMaterialShell.default

    # Devs
    #./devs/git.nix
    ./devs/nushell.nix
    ./devs/helix.nix
    #./devs/neovim.nix
    #./devs/vscode.nix
    #./devs/zed.nix
    ./devs/terminal.nix

    # Apps
    ./apps/chromium-flag.nix
    #./apps/qutebrowser.nix
    ./apps/zen-browser.nix
    #./apps/edge.nix
    ./apps/fuzzel.nix
    ./apps/obs.nix
    ./apps/twitch.nix
    ./apps/yazi.nix

    # Configs
    ./configs/vm.nix
    ./configs/mako.nix
    ./configs/niri.nix
    ./configs/rnnoise.nix
    ./configs/theme.nix
    ./configs/xdg.nix

    # Packages
    ./packages/gaming.nix
    ./packages/desktop.nix
    ./packages/productive.nix
    ./packages/development.nix
  ];
    home = {
      username = "spidy";
      homeDirectory = "/home/spidy";
      stateVersion = "26.05";
    };
  };
}
