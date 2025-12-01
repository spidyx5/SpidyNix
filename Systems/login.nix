#/etc/nixos/SpidyNix/Systems/login.nix
{ pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;

      # 1. AUTO LOGIN (Daily Use)
      # Immediately starts Niri as 'spidy' when you boot up.
      initial_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "Spidy";
      };

      # 2. FALLBACK (Maintenance Mode)
      # If you log out of Niri, or if Niri crashes, you get a text prompt.
      # Logging in here gives you a terminal to fix issues.
      default_session = {
        command = "${pkgs.greetd}/bin/agreety --cmd ${pkgs.bash}/bin/bash";
        user = "greeter";
      };
    };
  };
}