{
  description = "SpidyNix - Modular NixOS Configuration";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
     nur = {
       url = "github:nix-community/NUR";
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
   # niri = {
    #  url = "github:sodiboo/niri-flake";
    #  inputs.nixpkgs.follows = "nixpkgs";
   # };
    quickshell = {
      url = "github:outfoxxed/quickshell";
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
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs for the flake
  outputs = { self, nixpkgs, home-manager, chaotic, dms, zen-browser, nix-gaming, nix-index-db,
    musnix, spicetify-nix, helium-browser, nur, nix-topology, hosts, sops-nix, ... }@inputs:
  let
    # System architecture
    system = "x86_64-linux";
    # Nixpkgs packages
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # NixOS configuration
    nixosConfigurations.Spidy = nixpkgs.lib.nixosSystem {
      inherit system;

      # Only pass inputs. Do NOT pass 'pkgs' here to avoid conflicts.
      specialArgs = { inherit inputs; };

      # Modules to include in the configuration
      modules = [
         # Global Unfree Config (Fixes firmware/software errors)
         { nixpkgs.config.allowUnfree = true; }
        ./Nix/Spidy/configuration.nix
        inputs.spicetify-nix.nixosModules.default
        # User environment management
        home-manager.nixosModules.home-manager
        # Modules
        chaotic.nixosModules.default
        inputs.nix-gaming.nixosModules.pipewireLowLatency  # Low-latency PipeWire
        nix-gaming.nixosModules.platformOptimizations
        nix-index-db.nixosModules.nix-index
        inputs.musnix.nixosModules.musnix
        hosts.nixosModule { networking.stevenBlackHosts.enable = true; }
        #nur.modules.nixos.default
        sops-nix.nixosModules.sops
        nix-topology.nixosModules.default
        { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }
      ];
    };
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
        echo "  nix flake check          - Check flake for errors"
        echo "  nix flake show           - Show flake outputs"
        echo "  nixos-rebuild dry-build  - Test configuration"
        echo "  nixos-rebuild switch     - Apply configuration"
      '';
    };
  };
}

/*
# ============================================================================
# SPIDYNIX FLAKE CONFIGURATION
# ============================================================================
# This file configures the SpidyNix flake including:
#   - Inputs for various NixOS modules and utilities
#   - Outputs for NixOS configuration and development shell
#   - Modules for hardware, profile, and additional features
# ============================================================================

# NOTES
# ============================================================================
# FLAKE COMMANDS:
# - nix flake check          - Check flake for errors
# - nix flake show           - Show flake outputs
# - nixos-rebuild dry-build  - Test configuration
# - nixos-rebuild switch     - Apply configuration

# INPUTS:
# - nixpkgs: NixOS unstable channel
# - systems: Default Linux systems
# - flake-utils: Flake utilities
# - flake-compat: Flake compatibility
# - flake-parts: Flake parts
# - nvf: Nix version file
# - musnix: Musnix for music production
# - home-manager: Home Manager for user configuration
# - chaotic: Chaotic NYX for kernel and optimizations
# - niri: Niri window manager
# - stylix: Stylix for theming
# - quickshell: Quickshell for shell configuration
# - dms: Dank Material Shell
# - spicetify-nix: Spicetify for Spotify
# - zen-browser: Zen Browser
# - helium-browser: Helium Browser
# - nix-gaming: Nix Gaming
# - nix-index-db: Nix index database

# MODULES:
# - Global Unfree Config: Allows unfree packages
# - Host & Hardware: Hardware and host configuration
# - Profile: Profile configuration
# - Spicetify: Spotify customization
# - Chaotic: Chaotic NYX optimizations
# - Nix Gaming: Gaming optimizations
# - Nix Index: Nix index database
# - Musnix: Music production
# - Home Manager: User configuration
# - Flake Features: Experimental flake features

# DEVELOPMENT SHELL:
# - Includes Git, Alejandra, nixpkgs-fmt, and Nil
# - Provides commands for flake management
# - Useful for development and testing

# FORMATTER:
# - Alejandra for Nix file formatting
# - Ensures consistent formatting across the codebase

# TROUBLESHOOTING:
# - Flake errors: Check nix flake check
# - Configuration errors: Check nixos-rebuild dry-build
# - Module conflicts: Check module imports
# - Package conflicts: Check nixpkgs and inputs

# PERFORMANCE:
# - Use binary caches to avoid compilation
# - Enable auto-optimise-store to save space
# - Run garbage collection regularly
# - Use max-jobs = "auto" for parallel builds

# SECURITY:
# - Only add trusted binary caches
# - Verify public keys for caches
# - Don't accept-flake-config from untrusted sources
# - Keep system updated: nix flake update && nh os switch

# MUSL LIBC:
# - Lightweight alternative to glibc
# - Smaller binaries and memory footprint
# - Better static linking support
# - May break some packages (especially proprietary software)
# - NOT recommended for desktop systems
# - Best for servers or embedded systems
# - To enable: Uncomment the musl overlay section above

# LTO (LINK TIME OPTIMIZATION):
# - Optimizes across translation units at link time
# - Results in smaller and faster binaries
# - Can improve performance by 5-15%
# - Significantly increases build time (2-3x longer)
# - May break some packages with non-standard build systems
# - Recommended for performance-critical applications
# - To enable: Uncomment the LTO overlay section above

# COMPILER OPTIMIZATIONS:
# - -march=native: Optimize for your specific CPU
# - -mtune=native: Tune code for your CPU microarchitecture
# - -O3: Aggressive optimization level
# - -flto: Enable Link Time Optimization
# - -pipe: Use pipes instead of temp files (faster compilation)
# - -fomit-frame-pointer: Remove frame pointer (slight performance gain)
# - WARNING: These flags may break some packages
# - Test thoroughly before deploying to production

# BTRFS NO-COW FOR /NIX:
# - CoW (Copy-on-Write) can slow down Nix operations on Btrfs
# - The nixNoCow activation script disables CoW for /nix
# - This improves performance for Nix store operations
# - Applied automatically during system activation
# - Only affects Btrfs filesystems
# - Verify with: lsattr -d /nix (should show 'C' flag)

# PERFORMANCE TESTING:
# - Build time: hyperfine 'nixos-rebuild dry-build'
# - Binary size: du -sh /nix/store/*
# - Runtime performance: hyperfine 'command'
# - System benchmarks: phoronix-test-suite

# RECOMMENDED OPTIMIZATION STRATEGY:
# 1. Start with default configuration (no overlays)
# 2. Enable CoW disabling for /nix (already enabled)
# 3. Use binary caches to avoid compilation
# 4. If you need custom builds, enable LTO selectively
# 5. Test musl only for specific use cases (containers, etc.)
# 6. Use -march=native only for personal systems, not for distribution
*/
