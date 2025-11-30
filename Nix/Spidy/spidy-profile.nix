{ config, pkgs, lib, inputs, ... }:
{
  # ============================================================================
  # IMPORTS
  # ============================================================================
  # Core NixOS system modules
  imports = [
    ../../Systems/system.nix       # System services and configuration
    ../../Softwares/software.nix   # Software packages and services
  ];

  # ============================================================================
  # HOME MANAGER CONFIGURATION
  # ============================================================================
  # Per-profile home manager configuration for Spidy
  # ============================================================================
  home-manager = {
    useGlobalPkgs = true;                # Use global packages
    useUserPackages = true;             # Use user-specific packages
    extraSpecialArgs = { inherit inputs; };  # Pass inputs and user config to home-manager
    backupFileExtension = "backup";       # Backup existing files with .backup extension

    users.spidy = {
      imports = [
        ../../Homes/home.nix
      ];
    };
  };

  # ============================================================================
  # SOPS SECRETS CONFIGURATION
  # ============================================================================
  # Configure sops-nix for encrypted secrets
  # ============================================================================
  sops.defaultSopsFile = ../Secrets/secrets.yaml;
  sops.age.keyFile = "/home/spidy/.config/sops/age/keys.txt";

  sops.secrets.bitwarden_password = {};
  sops.secrets.bookmarks_data = {};
  sops.secrets.api_key = {};

  # ============================================================================
  # PROFILE-SPECIFIC SETTINGS
  # ============================================================================
  # Settings specific to the 'Spidy' profile
  # These override or extend the base system and software configurations
  # ============================================================================
  nix.settings.trusted-users = [ "root" "@wheel" ];  # Trust users in wheel group for nix commands
}
