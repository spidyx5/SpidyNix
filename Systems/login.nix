# /etc/nixos/SpidyNix/Systems/login.nix
{ config, pkgs, lib, inputs, ... }:
{
  # 1. Enable ReGreet
  # This automatically configures "services.greetd" to use a Cage wrapper.
  programs.regreet = {
    enable = true;
  };

  # 2. Enable Greetd
  services.greetd = {
    enable = true;
    # DO NOT put 'settings' here. programs.regreet handles it for you.
  };

  # ============================================================================
  # SESSIONS
  # ============================================================================
  environment.etc."greetd/environments".text = ''
    niri-session
    bash
    zsh
    fish
  '';

  # ============================================================================
  # SYSTEMD & ENVIRONMENT
  # ============================================================================
  
  # NOTE: I removed the XDG_ variables from here. 
  # You generally should NOT set XDG_CURRENT_DESKTOP in the greeter service
  # because the Greeter runs in Cage, but your actual session will run Niri.
  # Setting it here might confuse ReGreet or leak into your session.
  
  systemd.services.greetd = {
    serviceConfig = {
      # Keep the logs for debugging
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}