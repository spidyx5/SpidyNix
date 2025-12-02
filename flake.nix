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
    ...
  } @ inputs: let
    # System architecture
    system = "x86_64-linux";
    # Nixpkgs packages
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # NixOS configuration
    nixosConfigurations.Spidy = nixpkgs.lib.nixosSystem {
      # --- FIX START ---
      # We REMOVE 'inherit system;' from here.
      # Passing 'system' here is what causes the evaluation warning.
      
      # We only pass inputs via specialArgs
      specialArgs = {inherit inputs;};

      modules = [
        # We DEFINE the system here instead.
        # This resolves the 'stdenv.hostPlatform.system' warning.
        { nixpkgs.hostPlatform = system; }
        
        # Global Unfree Config
        {nixpkgs.config.allowUnfree = true;}
        
        # Your Configuration
        ./Nix/Spidy/configuration.nix
        
        # External Modules
        inputs.spicetify-nix.nixosModules.default
        sysc-greet.nixosModules.default
        home-manager.nixosModules.home-manager
        chaotic.nixosModules.default
        inputs.nix-gaming.nixosModules.pipewireLowLatency
        nix-gaming.nixosModules.platformOptimizations
        nix-index-db.nixosModules.nix-index
        inputs.musnix.nixosModules.musnix
        hosts.nixosModule {networking.stevenBlackHosts.enable = true;}
        nur.modules.nixos.default
        nix-topology.nixosModules.default
        
        # Experimental features
        {nix.settings.experimental-features = ["nix-command" "flakes"];}
      ];
      # --- FIX END ---
    };

    # Formatter
    formatter.${system} = pkgs.alejandra;

    # Development shell
    devShells.${system}.default = pkgs.mkShell {
      name = "SpidyNix-Dev";
      packages = [pkgs.git pkgs.alejandra pkgs.nixpkgs-fmt pkgs.nil];
      shellHook = ''
        echo "SpidyNix Development Shell"
      '';
    };
  };
}