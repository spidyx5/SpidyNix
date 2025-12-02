#/etc/nixos/SpidyNix/flake.nix
{
  description = "SpidyNix - Modular NixOS Configuration";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sysc-greet = {
      url = "github:Nomadcxx/sysc-greet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Development utilities
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

    # Audio/music production
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Performance optimizations & custom kernels
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop environment & window manager
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications & tools
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

    #sops-nix = {url = "github:Mic92/sops-nix";inputs.nixpkgs.follows = "nixpkgs";};

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
    #sops-nix,
    ...
  } @ inputs: let
    # System architecture
    system = "x86_64-linux";
    # Nixpkgs packages
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # NixOS configuration
    nixosConfigurations.Spidy = nixpkgs.lib.nixosSystem {
      inherit system;

      # Only pass inputs. Do NOT pass 'pkgs' here to avoid conflicts.
      specialArgs = {inherit inputs;};

      # Modules to include in the configuration
      modules = [
        # Global Unfree Config (Fixes firmware/software errors)
        {nixpkgs.config.allowUnfree = true;}
        ./Nix/Spidy/configuration.nix
        inputs.spicetify-nix.nixosModules.default
        sysc-greet.nixosModules.default
        # User environment management
        home-manager.nixosModules.home-manager
        # Modules
        chaotic.nixosModules.default
        inputs.nix-gaming.nixosModules.pipewireLowLatency # Low-latency PipeWire
        nix-gaming.nixosModules.platformOptimizations
        nix-index-db.nixosModules.nix-index
        inputs.musnix.nixosModules.musnix
        hosts.nixosModule {networking.stevenBlackHosts.enable = true;}
        nur.modules.nixos.default
        #sops-nix.nixosModules.sops
        nix-topology.nixosModules.default
        {nix.settings.experimental-features = ["nix-command" "flakes"];}
      ];
    };
    
    # Formatter for Nix files
    formatter.${system} = pkgs.alejandra;

    # Development shell
    devShells.${system}.default = pkgs.mkShell {
      name = "SpidyNix-Dev";
      packages = [pkgs.git pkgs.alejandra pkgs.nixpkgs-fmt pkgs.nil];

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