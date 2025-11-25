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
  # VIRTUALIZATION
  # ============================================================================
  # Options for virtual machines and containers
  options.virtualizationTools = {
    libvirt = lib.mkEnableOption "libvirt/QEMU/KVM for virtual machines";
    docker = lib.mkEnableOption "Docker container runtime";
    podman = lib.mkEnableOption "Podman container runtime";
    waydroid = lib.mkEnableOption "Waydroid Android emulation";
  };

  config = {
    # Default virtualization settings
    virtualizationTools = {
      libvirt = lib.mkDefault true;
      docker = lib.mkDefault false;
      podman = lib.mkDefault true;
      waydroid = lib.mkDefault false;
    };

    # ============================================================================
    # HOME MANAGER CONFIGURATION
    # ============================================================================
    # Per-profile home manager configuration for Spidy
    # ============================================================================
    home-manager = {
      useGlobalPkgs = true;                # Use global packages
      useUserPackages = true;             # Use user-specific packages
      extraSpecialArgs = { inherit inputs; userConfig = import ../../user-config.nix; };  # Pass inputs and user config to home-manager
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
    # HARDWARE TYPE CONFIGURATION
    # ============================================================================
    # Set hardware type based on user configuration
    # ============================================================================
    hardwareType = config.home-manager.users.spidy.myConfig.hardwareType;

    # ============================================================================
    # PROFILE-SPECIFIC SETTINGS
    # ============================================================================
    # Settings specific to the 'Spidy' profile
    # These override or extend the base system and software configurations
    # ============================================================================
    nix.settings.trusted-users = [ "root" "@wheel" ];  # Trust users in wheel group for nix commands
  };
}
