#/etc/nixos/SpidyNix/Systems/login.nix
{ config, lib, pkgs, username... }:

{
  services.greetd = lib.mkIf (!config.services."sysc-greet".enable) {
    enable = true;

    settings = {


      # 1. AUTO LOGIN (Daily Use)
      initial_session = {
        user = "spidy";
        command = "${pkgs.niri}/bin/niri-session";
      };

      # 2. FALLBACK (Maintenance Mode)
      default_session = {
        user = "spidy";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
      };
    };
  };
}
