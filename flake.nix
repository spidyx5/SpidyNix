# /etc/nixos/SpidyNix/flake.nix
{
  description = "SpidyNix - Modular NixOS Configuration";

  inputs = {
    # ========================================================================
    # CORE DEPENDENCIES
    # ========================================================================
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sysc-greet = {
      url = "github:Nomadcxx/sysc-greet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ========================================================================
    # DEVELOPMENT UTILITIES
    # ========================================================================
    systems.url = "github:nix-systems/default-linux";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-compat.url = "github:edolstra/flake-compat";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # ========================================================================
    # AUDIO & MUSIC PRODUCTION
    # ========================================================================
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ========================================================================
    # USER ENVIRONMENT
    # ========================================================================
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ========================================================================
    # PERFORMANCE & KERNELS
    # ========================================================================
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ========================================================================
    # DESKTOP & WINDOW MANAGERS
    # ========================================================================
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ========================================================================
    # APPLICATIONS & TOOLS
    # ========================================================================
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-browser = {
      url = "github:fpletz/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix = {url = "github:Mic92/sops-nix";inputs.nixpkgs.follows = "nixpkgs";};

    hosts.url = "github:StevenBlack/hosts";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs for the flake
  outputs = {
    self,
    nixpkgs,
    home-manager,
    chaotic,
    dms,
    zen-browser,
    nix-gaming,
    nix-index-db,
    musnix,
    spicetify-nix,
    helium-browser,
    sysc-greet,
    niri,
    nur,
    nix-topology,
    hosts,
    # sops-nix,
    ...
  } @ inputs: let
    # System architecture
    system = "x86_64-linux";
    # Nixpkgs packages (Used for devShell and formatter only)
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # ========================================================================
    # NIXOS CONFIGURATION
    # ========================================================================
    nixosConfigurations.Spidy = nixpkgs.lib.nixosSystem {
      # We do not pass 'system' here anymore; it is defined in modules below.
      
      # Pass inputs to modules
      specialArgs = { inherit inputs; };

      # Modules to include in the configuration
      modules = [
        # 1. Define System Architecture (Modern Method)
        { nixpkgs.hostPlatform = system; }
        
        # 2. Global Config
        { nixpkgs.config.allowUnfree = true; }
        { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }

        # 3. Core Configuration
        ./Nix/Spidy/configuration.nix

        # 4. Flake Modules
        inputs.spicetify-nix.nixosModules.default
        sysc-greet.nixosModules.default
        home-manager.nixosModules.home-manager
        chaotic.nixosModules.default
        inputs.nix-gaming.nixosModules.pipewireLowLatency
        nix-gaming.nixosModules.platformOptimizations
        nix-index-db.nixosModules.nix-index
        inputs.musnix.nixosModules.musnix
        hosts.nixosModule { networking.stevenBlackHosts.enable = true; }
        nur.modules.nixos.default
        nix-topology.nixosModules.default
        # sops-nix.nixosModules.sops
      ];
    };
    
    # ========================================================================
    # PACKAGE OUTPUTS (Fixes 'nix flake check' error)
    # ========================================================================
    packages.${system}.default = self.nixosConfigurations.Spidy.config.system.build.toplevel;

    # ========================================================================
    # UTILITIES
    # ========================================================================
    # Formatter for Nix files
    formatter.${system} = pkgs.alejandra;

    # Development shell
    devShells.${system}.default = pkgs.mkShell {
      name = "SpidyNix-Dev";
      packages = [ pkgs.git pkgs.alejandra pkgs.nixpkgs-fmt pkgs.nil ];

      shellHook = ''
        echo "SpidyNix Development Shell"
        echo "=========================="
        echo "Available commands:"
        echo " nix flake check - Check flake for errors"
        echo " nix flake show - Show flake outputs"
        echo " nixos-rebuild dry-build - Test configuration"
        echo " nixos-rebuild switch - Apply configuration"
      '';
    };
  };
}
# FLAKE COMMANDS:
# - nix flake check - Check flake for errors
# - nix flake show - Show flake outputs
# - nixos-rebuild dry-build - Test configuration
# - nixos-rebuild switch - Apply configuration