{ config, pkgs, lib, inputs, ... }:

let
  # Helper function to spawn noctalia commands
  noctalia = cmd: [ "noctalia-shell" "ipc" "call" ] ++ lib.strings.splitString " " cmd;
in
{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    };
  }
  programs.niri = {
    settings = {
      # ...
      spawn-at-startup = [
        {
          command = [
            "noctalia-shell"
          ];
        }
      ];
    };
  };
}
