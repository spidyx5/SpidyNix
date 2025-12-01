# /etc/nixos/SpidyNix/Systems/nixos.nix
{ config, pkgs, lib, inputs, ... }:
{
  # ============================================================================
  # NIX PACKAGE MANAGER SETTINGS
  # ============================================================================
  # Core Nix configuration with performance optimizations
  # ============================================================================
  # Replace standard Nix with Lix for better performance
  nix.package = pkgs.lix;

  nix = {
    # Store and build optimizations
    settings = {
      auto-optimise-store = true;     # Automatically deduplicate store files
      builders-use-substitutes = true; # Allow builders to use binary caches
      max-jobs = "auto";              # Automatically determine parallel builds
      cores = 0;                      # Use all available cores
      sandbox = true;                 # Build packages in isolated environment
      keep-derivations = true;        # Keep derivations for direnv
      keep-outputs = true;           # Keep outputs for direnv
      warn-dirty = false;            # Don't warn about dirty git trees
      accept-flake-config = false;   # Security: Don't auto-accept flake configs

      trusted-users = [ "root" "@wheel" ]; # Users who can control Nix operations
    };

    # Enable automatic store optimization
    optimise.automatic = true;

    # Binary caches for faster package installation
    settings.substituters = [
      "https://cache.nixos.org?priority=10"    # Official NixOS (highest priority)
      "https://chaotic-nyx.cachix.org"         # Performance-optimized packages
      "https://nix-gaming.cachix.org"          # Gaming packages
      "https://niri.cachix.org"               # Window manager
      "https://nix-community.cachix.org"      # Community-maintained packages
    ];

    settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # Flake registry for consistent inputs
    registry = lib.mapAttrs (_: v: { flake = v; })
      (lib.filterAttrs (_: v: lib.isType "flake" v) inputs);

    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    settings.flake-registry = "/etc/nix/registry.json";
  };

  # ============================================================================
  # NH - NIX HELPER
  # ============================================================================
  # NH is a helper tool that simplifies common NixOS operations
  # Commands: nh os switch, nh os boot, nh clean, nh search, etc.
  # ============================================================================
  # Set NH default flake location
  environment.variables.FLAKE = "/etc/nixos/SpidyNix";

  # ============================================================================
  # NIXPKGS CONFIGURATION
  # ============================================================================
  # Nixpkgs-specific settings
  # ============================================================================
  nixpkgs.config = {
    allowUnsupportedSystem = false;
    allowBroken = false;
    # Allow unfree packages (needed for Steam, Discord, NVIDIA drivers, etc.)
    allowUnfree = true;

    # Allow insecure packages (use with caution)
    permittedInsecurePackages = [
      #"electron"
    ];

    # Compiler optimization flags
 #   stdenv.adhesionCompilerFlags = [
   #   "-O3"  # Aggressive optimization
   #   "-march=x86-64-v3"  # Optimize for modern x86-64 CPUs
   #   "-flto=auto"  # Enable Link Time Optimization
   #   "-fuse-ld=mold"  # Use mold linker
   #   "-fomit-frame-pointer"  # Omit frame pointer for performance
   #   "-ffunction-sections"  # Place each function in its own section
    #  "-fdata-sections"  # Place each data item in its own section
    #  "-Wl,--gc-sections"  # Garbage collect unused sections
    #];
  };

  # ============================================================================
  # SYSTEM ACTIVATION SCRIPTS
  # ============================================================================
  # Scripts that run during system activation
  # ============================================================================
  system.activationScripts = {
    # Disable Copy-on-Write for /nix store on Btrfs
    # Improves performance for Nix store on Btrfs filesystems
    nixNoCow = lib.stringAfter [ "var" ] ''
      if [ -d /nix ] && command -v chattr &> /dev/null; then
        echo "Disabling CoW for /nix store..."
        chattr +C /nix 2>/dev/null || true
        find /nix -type d -exec chattr +C {} \; 2>/dev/null || true
      fi
    '';
  };
}
# ============================================================================
# NIXOS CORE CONFIGURATION (LLVM/Clang Toolchain + Aggressive Optimizations)
# ============================================================================
# This file configures core NixOS and Nix package manager settings including:
#   - Nix experimental features (flakes, new commands)
#   - Binary caches for faster builds
#   - Garbage collection and store optimization
#   - NH (Nix Helper) for easier system management
#   - Nix daemon settings
# ============================================================================
# NOTES
# ============================================================================
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
#
# NH COMMANDS (Easier alternatives):
# - nh os switch                      - Rebuild and switch
# - nh os boot                        - Rebuild for next boot
# - nh os test                        - Test configuration
# - nh clean all                      - Clean old generations
# - nh clean profile --keep 3         - Keep last 3 generations
# - nh search <package>               - Search for packages
#
# BINARY CACHES:
# - cache.nixos.org: Official NixOS binary cache
# - chaotic-nyx: CachyOS kernel, optimized packages
# - nix-gaming: Gaming-related packages (GameMode, MangoHud, etc.)
# - niri.cachix.org: Niri window manager
# - nix-community: Community-maintained packages
#
# GARBAGE COLLECTION:
# - Runs weekly automatically
# - Keeps last 7 days of generations
# - NH clean keeps last 3 generations
# - Manual cleanup: nix-collect-garbage -d
#
# STORE OPTIMIZATION:
# - Auto-optimise-store: Deduplicates identical files
# - Saves disk space (can save 10-30GB)
# - Runs automatically during builds
# - Manual run: nix-store --optimise
#
# TRUSTED USERS:
# - root: Full Nix access
# - @wheel: Users in wheel group can build without restrictions
# - Other users: Limited access, can't override settings
#
# FLAKES:
# - Reproducible configuration management
# - Locked dependencies in flake.lock
# - Share configurations easily
# - Update specific inputs: nix flake lock --update-input nixpkgs
#
# NIX STORE:
# - Location: /nix/store
# - Read-only: Cannot be modified directly
# - Content-addressed: Files identified by hash
# - Shared: Multiple packages can share files
#
# TROUBLESHOOTING:
# - Build failures: Check nix-build with --keep-failed
# - Cache issues: Clear cache with nix-store --verify --check-contents
# - Flake issues: Delete flake.lock and re-run
# - Store corruption: nix-store --verify --check-contents --repair
#
# PERFORMANCE TIPS:
# - Use binary caches to avoid compilation
# - Enable auto-optimise-store to save space
# - Run garbage collection regularly
# - Use max-jobs = "auto" for parallel builds
#
# SECURITY:
# - Only add trusted binary caches
# - Verify public keys for caches
# - Don't accept-flake-config from untrusted sources
# - Keep system updated: nix flake update && nh os switch
#
# MUSL LIBC:
# - Lightweight alternative to glibc
# - Smaller binaries and memory footprint
# - Better static linking support
# - May break some packages (especially proprietary software)
# - NOT recommended for desktop systems
# - Best for servers or embedded systems
# - To enable: Uncomment the musl overlay section above
#
# LTO (LINK TIME OPTIMIZATION):
# - Optimizes across translation units at link time
# - Results in smaller and faster binaries
# - Can improve performance by 5-15%
# - Significantly increases build time (2-3x longer)
# - May break some packages with non-standard build systems
# - Recommended for performance-critical applications
# - To enable: Uncomment the LTO overlay section above
#
# COMPILER OPTIMIZATIONS:
# - -march=native: Optimize for your specific CPU
# - -mtune=native: Tune code for your CPU microarchitecture
# - -O3: Aggressive optimization level
# - -flto: Enable Link Time Optimization
# - -pipe: Use pipes instead of temp files (faster compilation)
# - -fomit-frame-pointer: Remove frame pointer (slight performance gain)
# - WARNING: These flags may break some packages
# - Test thoroughly before deploying to production
#
# BTRFS NO-COW FOR /NIX:
# - CoW (Copy-on-Write) can slow down Nix operations on Btrfs
# - The nixNoCow activation script disables CoW for /nix
# - This improves performance for Nix store operations
# - Applied automatically during system activation
# - Only affects Btrfs filesystems
# - Verify with: lsattr -d /nix (should show 'C' flag)
#
# PERFORMANCE TESTING:
# - Build time: hyperfine 'nixos-rebuild dry-build'
# - Binary size: du -sh /nix/store/*
# - Runtime performance: hyperfine 'command'
# - System benchmarks: phoronix-test-suite
#
# RECOMMENDED OPTIMIZATION STRATEGY:
# 1. Start with default configuration (no overlays)
# 2. Enable CoW disabling for /nix (already enabled)
# 3. Use binary caches to avoid compilation
# 4. If you need custom builds, enable LTO selectively
# 5. Test musl only for specific use cases (containers, etc.)
# 6. Use -march=native only for personal systems, not for distribution
# ============================================================================
#     NIXOS OPTIMIZATIONS
# ============================================================================
# Reference
# nixpkgs.overlays = [
#   (self: super: {
#     musl = super.musl_1_2_4;
#   })
# ];
# -march=native
# LTO (LINK TIME OPTIMIZATION) - Reference
# nixpkgs.overlays = [
#   (self: super: {
#     stdenv = super.withCFlags [
#       "-flto"
#       "-fuse-linker-plugin"
#       "-ffat-lto-objects"
#     ] super.stdenv;
#   })
# ];
# Alternative: Enable LTO with clang/LLVM
# nixpkgs.overlays = [
#   (self: super: {
#     stdenv = super.llvmPackages_latest.stdenv;
#   })
# ];
# --- Combined Overlays Configuration ---
# nixpkgs.overlays = [
#   (final: prev: {
#     stdenv = prev.llvmPackages.stdenv.override {
#       cc = prev.llvmPackages.clang;
#       bintools = prev.mold-wrapped;
#       libcxx = prev.llvmPackages.libcxx;
#       libcxxabi = prev.llvmPackages.libcxxabi;
#     };
#   })
# ];
# ============================================================================
# MUSL LIBC OPTIMIZATION (Optional)
# nixpkgs.overlays = [
#   (self: super: {
#     # Replace stdenv with musl-based stdenv
#     stdenv = super.stdenvAdapters.useMoldLinker (
#       super.stdenvAdapters.makeStaticLibraries super.pkgsMusl.stdenv
#     );
#   })
# ];
# ============================================================================
