#/etc/nixos/SpidyNix/Systems/login.nix
{ pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      
      # 1. Auto-login into Niri on boot
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "spidy";
      };

      # 2. If Niri crashes or you log out, show a text login prompt
      default_session = {
        command = "${pkgs.greetd.agreety}/bin/agreety --cmd ${pkgs.bash}/bin/bash";
        user = "greeter";
      };
    };
  };
}