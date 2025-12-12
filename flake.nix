{
  description = "SpidyNix - Modular NixOS configuration with Niri WM";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default-linux";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    chaotic.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-compat.url = "github:edolstra/flake-compat";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-browser = {
      url = "github:fpletz/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hosts.url = "github:StevenBlack/hosts";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ 
    self,
    nixpkgs, 
    home-manager, 
    chaotic, 
    niri,
    zen-browser, 
    flake-utils, 
    musnix, 
    spicetify-nix, 
    helium-browser, 
    nix-gaming, 
    nix-index-db, 
    nur, 
    nix-topology, 
    hosts, 
    sops-nix,
    dankMaterialShell, 
    ... }:
    let
      system = "x86_64-linux";
      
      # Create a nixpkgs instance with overlays applied
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ./Systems/overlay.nix)
          inputs.niri.overlays.niri
        ];
      };
    in
    {
      # ===================================================================
      # SPIDY PROFILE - MAIN CONFIGURATION
      # ===================================================================
      nixosConfigurations.Spidy = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./Spidy/spidy-config.nix
          chaotic.nixosModules.default
          #niri.nixosModules.niri
          home-manager.nixosModules.home-manager
          musnix.nixosModules.musnix
          spicetify-nix.nixosModules.default
          nix-gaming.nixosModules.pipewireLowLatency
          nix-gaming.nixosModules.platformOptimizations
          nix-index-db.nixosModules.nix-index
          nur.modules.nixos.default
          hosts.nixosModule { networking.stevenBlackHosts.enable = true; }
          nix-topology.nixosModules.default
          sops-nix.nixosModules.sops
          dankMaterialShell.nixosModules.greeter

          {
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
      # ===================================================================
      # DEVELOPMENT SHELL
      # ===================================================================
      devShells.${pkgs.stdenv.hostPlatform.system}.default = pkgs.mkShell {
        name = "SpidyNix-Dev";
        packages = with pkgs; [
          git
          alejandra
          nixpkgs-fmt
          statix
        ];

        shellHook = ''
          echo "SpidyNix Development Shell"
          echo "=========================="
          echo "Available commands:"
          echo " nix flake check         - Check flake for errors"
          echo " nix flake show          - Show flake outputs"
          echo " nh os test              - Test configuration"
          echo " nh os switch            - Apply configuration"
          echo " nix flake update        - Update inputs"
        '';
      };

      # ===================================================================
      # FORMATTER
      # ===================================================================
      formatter.${pkgs.stdenv.hostPlatform.system} = pkgs.alejandra;

      # ===================================================================
      # DEFAULT PACKAGE
      # ===================================================================
      packages.${pkgs.stdenv.hostPlatform.system}.default = self.nixosConfigurations.Spidy.config.system.build.toplevel;
    };
}
# FLAKE COMMANDS:
# - nix flake check - Check flake for errors
# - nix flake show - Show flake outputs
# - nixos-rebuild dry-build - Test configuration
# - nixos-rebuild switch - Apply configuration