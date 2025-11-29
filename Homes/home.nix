# /etc/nixos/SpidyNix/Homes/home.nix
{ config, pkgs, lib, inputs, userConfig, ... }:

{
  # ============================================================================
  # IMPORTS
  # ============================================================================
  imports = [
    # Window Managers
    inputs.niri.homeModules.niri
    inputs.dms.homeModules.dankMaterialShell.default


    # Development tools (always included)
    ./devs/git.nix
    ./devs/nushell.nix

    # Editors (conditionally enabled based on config)
    ./devs/helix.nix
    ./devs/neovim.nix
    ./devs/vscode.nix
    ./devs/zed.nix

    # Browsers (conditionally enabled based on config)
    ./apps/chromium-flag.nix
    ./apps/qutebrowser.nix
    ./apps/zen-browser.nix

    # Terminals (conditionally enabled based on config)
    ./devs/terminal.nix

    # Features (conditionally enabled based on config)
    ./configs/vm.nix
    ./packages/gaming.nix
    ./packages/desktop.nix
    ./packages/productive.nix
    ./packages/development.nix
  ];

  # ============================================================================
  # USER CONFIGURATION OPTIONS
  # ============================================================================
  # Enable/disable components for easy customization
  # Modify these options to change your setup
  # ============================================================================

  options.myConfig = {
    # Window Managers
    wm = {
      niri = lib.mkEnableOption "Enable Niri window manager";
    };

    # Editors
    editors = {
      helix = lib.mkEnableOption "Enable Helix editor";
      neovim = lib.mkEnableOption "Enable Neovim editor";
      vscode = lib.mkEnableOption "Enable VSCode editor";
      zed = lib.mkEnableOption "Enable Zed editor";
    };

    # Browsers
    browsers = {
      chromium = lib.mkEnableOption "Enable Chromium browser";
      qutebrowser = lib.mkEnableOption "Enable Qutebrowser";
      zen = lib.mkEnableOption "Enable Zen browser";
    };

    # Terminals
    terminals = {
      kitty = lib.mkEnableOption "Enable Kitty terminal";
    };

    # Features
    virtualization = lib.mkEnableOption "Enable virtualization tools";
    gaming = lib.mkEnableOption "Enable gaming tools";

    # Productivity software
    productivity = {
      davinciResolve = lib.mkEnableOption "Enable DaVinci Resolve";
      davinciResolveStudio = lib.mkEnableOption "Enable DaVinci Resolve Studio";
    };

    # Hardware type configuration
    hardwareType = {
      intel = lib.mkEnableOption "Intel hardware configuration";
      amd = lib.mkEnableOption "AMD hardware configuration";
      nvidia = lib.mkEnableOption "NVIDIA hardware configuration";
      vm = lib.mkEnableOption "VM hardware configuration";
    };

    # Virtualization tools (individual components)
    virtualizationTools = {
      libvirt = lib.mkEnableOption "Enable libvirt/QEMU/KVM for virtual machines";
      docker = lib.mkEnableOption "Enable Docker container runtime";
      podman = lib.mkEnableOption "Enable Podman container runtime";
      waydroid = lib.mkEnableOption "Enable Waydroid Android emulation";
    };

    # System preferences (user-configurable)
    systemPrefs = {
      timezone = lib.mkOption {
        type = lib.types.str;
        default = "Asia/Singapore";
        description = "System timezone (e.g., 'America/New_York', 'Europe/London')";
      };

      keyboard = {
        layout = lib.mkOption {
          type = lib.types.str;
          default = "us";
          description = "XKB keyboard layout (fallback when not using keyd)";
        };

        variant = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "XKB keyboard layout variant";
        };
      };
    };
  };

  # ============================================================================
  # CONFIGURATION
  # ============================================================================

  config = {

    # ==========================================================================
    # USER CONFIGURATION
    # ==========================================================================
    # Apply user configuration from extraSpecialArgs
    # ==========================================================================
    myConfig = userConfig.myConfig;


    # ============================================================================
    # REQUIRED HOME MANAGER SETTINGS
    # ============================================================================
    home = {
      username = "spidy";
      homeDirectory = "/home/spidy";
      stateVersion = "26.05";
    };
  };
}
