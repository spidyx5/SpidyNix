{ config, pkgs, lib, inputs, ... }:

{
  # =========================================================================
  # HOME MANAGER CONFIGURATION
  # =========================================================================
  # Main entry point for user 'spidy' home configuration
  # Imports all application, dotfile, and config modules
  # =========================================================================

  imports = [
    ./app/git.nix
    ./app/helix.nix
    #./app/neovim.nix
    ./app/nushell.nix
    ./app/starship.nix
    #./app/vscode.nix
    #./app/zed.nix
    ./app/xdg.nix


    #./dotfile/dms.nix
    ./dotfile/noctalia.nix
    ./dotfile/niri.nix
    ./dotfile/theme.nix
    ./dotfile/wayland.nix
    ./dotfile/yazi.nix
    ./dotfile/mako.nix
    ./dotfile/fuzzel.nix


    ./config/chromium.nix
    #./config/edge.nix
    ./config/obs.nix
    #./config/qutebrowser.nix
    ./config/rnnoise.nix
    ./config/twitch.nix
    ./config/vm.nix
    ./config/zen.nix


    #inputs.niri.homeModules.niri  
    #inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
    #inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.noctalia.homeModules.default
    #inputs.dankMaterialShell.nixosModules.greeter
  ];

  # =========================================================================
  # HOME MANAGER BASICS
  # =========================================================================
  home.username = "spidy";
  home.homeDirectory = "/home/spidy";
  home.stateVersion = "26.05";

  # =========================================================================
  # PROGRAMS
  # =========================================================================
  programs.home-manager.enable = true;

  # =========================================================================
  # HOME PACKAGES
  # =========================================================================
  home.packages = with pkgs; [
    # Add any user-specific packages here
  ];
}
