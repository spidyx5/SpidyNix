{ config, pkgs, lib, inputs, ... }:

{
  # =========================================================================
  # DMS SHELL - STARTUP CONFIGURATION
  # =========================================================================
  # Custom startup behavior for DMS shell environment
  # Clipboard history tracking and quick settings launcher
  # =========================================================================
  programs.dank-material-shell = {
  enable = true;
  niri = {
    enableKeybinds = true;   # Automatic keybinding configuration
    enableSpawn = true;      # Auto-start DMS with niri
  };
};

  programs.niri.settings.spawn-at-startup = [
    {
      command = [ "wl-paste" "--watch" "cliphist" "store" ];
    }
    {
      command = [ "wl-paste" "--type" "text" "--watch" "cliphist" "store" ];
    }
    {
      command = [ "qs" "-c" "dms" ];
    }
  ];
}
