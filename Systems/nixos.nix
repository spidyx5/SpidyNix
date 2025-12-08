{ pkgs, lib, config, inputs, ... }:

{
  nix.package = pkgs.nix;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      max-jobs = "auto";
      cores = 0;
      sandbox = true;
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;
      accept-flake-config = false;
      trusted-users = [ "root" "@wheel" ];

      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://chaotic-nyx.cachix.org?priority=12"
        "https://nix-gaming.cachix.org"
        "https://niri.cachix.org"
        "https://nix-community.cachix.org?priority=8"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    registry = lib.mapAttrs (_: v: { flake = v; })
      (lib.filterAttrs (_: v: lib.isType "flake" v) inputs);

    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    settings.flake-registry = "/etc/nix/registry.json";
  };

  environment.variables.FLAKE = "/etc/nixos/SpidyNix";

  nixpkgs.config = {
    allowUnsupportedSystem = false;
    allowBroken = false;
    allowUnfree = true;
    permittedInsecurePackages = [
    ];
  };

  system.activationScripts = {
    nixNoCow = lib.stringAfter [ "var" ] ''
      if [ -d /nix ] && command -v chattr &> /dev/null; then
        echo "Disabling CoW for /nix store..."
        chattr +C /nix 2>/dev/null || true
        find /nix -type d -exec chattr +C {} \; 2>/dev/null || true
      fi
    '';
  };

  # ============================================================================
  # TIMEZONE & LOCALIZATION
  # ============================================================================
  time.timeZone = "Asia/Singapore";

  i18n = {
    defaultLocale = "en_SG.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_SG.UTF-8";
      LC_IDENTIFICATION = "en_SG.UTF-8";
      LC_MEASUREMENT = "en_SG.UTF-8";
      LC_MONETARY = "en_SG.UTF-8";
      LC_NAME = "en_SG.UTF-8";
      LC_NUMERIC = "en_SG.UTF-8";
      LC_PAPER = "en_SG.UTF-8";
      LC_TELEPHONE = "en_SG.UTF-8";
      LC_TIME = "en_SG.UTF-8";
    };
  };

  # ============================================================================
  # USER ACCOUNTS
  # ============================================================================
  users.users.spidy = {
    isNormalUser = true;
    description = "Good Spidy";
    home = "/home/spidy";
    shell = pkgs.nushell;
    extraGroups = [
      "wheel"          # Sudo access
      "networkmanager" # Network configuration
      "audio"          # Audio devices
      "video"          # Video devices
      "input"          # Input devices
      "libvirtd"       # Virtual machine management
      "kvm"            # KVM virtualization
      "adbusers"       # Android Debug Bridge
      "plugdev"        # Pluggable devices
      "docker"         # Docker containers
    ];
    password = "spidy";
  };

  users.defaultUserShell = pkgs.nushell;

  # ============================================================================
  # SUDO CONFIGURATION
  # ============================================================================
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      Defaults timestamp_timeout=3
      Defaults passwd_timeout=0
    '';
  };

  # ============================================================================
  # KEYD - KEYBOARD REMAPPING
  # ============================================================================
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          q = "q"; w = "w"; e = "f"; r = "p"; t = "b"; y = "j"; u = "l"; i = "u"; o = "y"; p = ";";
          a = "a"; s = "r"; d = "s"; f = "t"; g = "g"; h = "m"; j = "n"; k = "e"; l = "i"; ";" = "o";
          z = "x"; x = "c"; c = "d"; v = "v"; b = "z"; n = "k"; m = "h"; "," = ","; "." = "."; "/" = "/";
          capslock = "backspace";
        };
      };
    };
  };
}
# NH COMMANDS (Easier alternatives):
# - nh os switch                      - Rebuild and switch
# - nh os boot                        - Rebuild for next boot
# - nh os test                        - Test configuration
# - nh clean all                      - Clean old generations
# - nh clean profile --keep 3         - Keep last 3 generations
# - nh search <package>               - Search for packages
# TROUBLESHOOTING:
# - Build failures: Check nix-build with --keep-failed
# - Cache issues: Clear cache with nix-store --verify --check-contents
# - Flake issues: Delete flake.lock and re-run
# - Store corruption: nix-store --verify --check-contents --repair

# NIX COMMANDS:
# - nix flake update                  - Update flake inputs
# - nix flake check                   - Check flake for errors
# - nix flake show                    - Show flake outputs
# - nixos-rebuild switch --flake .#   - Rebuild and activate
# - nixos-rebuild boot --flake .#     - Rebuild for next boot
# - nixos-rebuild dry-build --flake .# - Test build without activation
# - nix-collect-garbage -d            - Delete old generations
# - nix-store --gc                    - Garbage collect unused packages
# - nix-store --optimise              - Deduplicate store files
