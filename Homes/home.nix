# /etc/nixos/SpidyNix/Homes/home.nix
{ config, pkgs, lib, inputs, ... }:

{
  # ============================================================================
  # IMPORTS
  # ============================================================================
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
    #inputs.niri.homeModules.niri
    # Devs
    ./devs/git.nix
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

  config.home = {
    username = "spidy";
    homeDirectory = "/home/spidy";
    stateVersion = "26.05";
  };
}
