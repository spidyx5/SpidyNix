# /etc/nixos/SpidyNix/Nix/Spooda/spooda-profile.nix
{ config, pkgs, lib, inputs, ... }:

{
  # ============================================================================
  # VIRTUALIZATION OPTIONS
  # ============================================================================
  # Options to enable/disable individual virtualization tools
  # ============================================================================
  options.virtualizationTools = {
    libvirt = lib.mkEnableOption "Enable libvirt/QEMU/KVM for virtual machines";
    docker = lib.mkEnableOption "Enable Docker container runtime";
    podman = lib.mkEnableOption "Enable Podman container runtime";
    waydroid = lib.mkEnableOption "Enable Waydroid Android emulation";
  };

  config = {
    # Default settings for virtualization tools
    virtualizationTools = {
      libvirt = lib.mkDefault true;    # Enable by default for VM support
      docker = lib.mkDefault false;    # Disabled by default (conflicts with podman)
      podman = lib.mkDefault true;     # Enable by default for containers
      waydroid = lib.mkDefault false;  # Disabled by default (Android emulation)
    };

  # ============================================================================
  # SPOODA EXPERIMENTAL PROFILE
  # ============================================================================
  # Experimental configuration for testing different setups
  # Uses Sway WM instead of Niri, different editors/browsers
  # ============================================================================

  # Experimental environment variables
  environment.variables = {
    SPOODA_EXPERIMENTAL = "true";
    EXPERIMENTAL_HOST = "spooda";
  };

  # ============================================================================
  # HOME MANAGER CONFIGURATION
  # ============================================================================
  # Per-profile home manager configuration for spooda
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

      myConfig = {
        # Use different editors for experimentation
        editors.helix = lib.mkForce false;
        editors.neovim = lib.mkForce true;  # Try Neovim
        editors.vscode = lib.mkForce false;
        editors.zed = lib.mkForce false;

        # Use different browsers
        browsers.chromium = lib.mkForce true;  # Try Chromium
        browsers.qutebrowser = lib.mkForce false;
        browsers.zen = lib.mkForce false;

        # Keep other defaults
        wm.niri = lib.mkForce true;
        terminals.kitty = lib.mkForce true;
        virtualization = lib.mkForce true;
        gaming = lib.mkForce true;
      };
    };
  };

  # Experimental system packages
  environment.systemPackages = with pkgs; [
    # Additional experimental tools
    neofetch        # System info
    htop           # Process viewer
    ranger         # File manager
  ];

  # ============================================================================
  # HARDWARE TYPE CONFIGURATION
  # ============================================================================
  # Set hardware type based on user configuration
  # ============================================================================
  hardwareType = config.home-manager.users.spidy.myConfig.hardwareType;

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
  # EXPERIMENTAL PROFILE NOTES
  # ============================================================================
  # This profile configures spooda as an experimental environment:
  # - Neovim editor (vim-based)
  # - Chromium browser (Google-based)
  # - Additional system monitoring tools
  #
  # Use this to test different editors/browsers before applying to main system
  # ============================================================================
  };
}
