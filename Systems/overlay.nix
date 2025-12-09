final: prev:

let
  # Aggressive optimization flags for x86-64-v3 (Zen 1, Skylake and newer)
  aggressiveCFlags = [
    "-O3"                      # Maximum optimization
    "-march=x86-64-v3"         # Modern x86-64 with AVX2, BMI, etc
    "-mtune=generic"           # Tune for generic modern CPUs
    "-flto=auto"               # Link Time Optimization with auto parallelization
    "-fomit-frame-pointer"     # Remove frame pointer for slight speed gain
    "-ffunction-sections"      # Separate function sections for better GC
    "-fdata-sections"          # Separate data sections for better GC
    "-fno-semantic-interposition" # Allow better optimizations
    "-fno-signed-zeros"        # Assume no signed zeros in FP math
    "-ffast-math"              # Enable fast math approximations
  ];

  # Linker optimization flags
  aggressiveLdFlags = [
    "-fuse-ld=mold"            # Use mold linker (faster than GNU ld/gold)
    "-Wl,--gc-sections"        # Garbage collect unused sections
    "-Wl,--as-needed"          # Link only needed libraries
    "-Wl,-O2"                  # Linker optimization level 2
  ];

  # String concatenation for environment variables
  cflagsStr = prev.lib.concatStringsSep " " aggressiveCFlags;
  ldflagsStr = prev.lib.concatStringsSep " " aggressiveLdFlags;

  # ============================================================================
  # OPTION 1: Use LLVM/Clang with modern LTO and mold
  # ============================================================================
  # Create a resilient llvm-based stdenv when available in the `prev` set.
  # Some nixpkgs trees expose `llvmPackages_latest`, others may not — avoid
  # failing evaluation by falling back to `prev.stdenv` when needed.
  llvmStdenv = let
    llvmPkgs = if prev ? llvmPackages_latest then prev.llvmPackages_latest
               else if prev ? llvmPackages then prev.llvmPackages
               else null;

    moldPkg = if prev ? mold then prev.mold
              else if prev ? "binutils-unwrapped" then prev."binutils-unwrapped"
              else if prev ? binutils_unwrapped then prev.binutils_unwrapped
              else prev.binutils; # last resort

    ccChoice = if llvmPkgs != null && llvmPkgs ? clang then llvmPkgs.clang else prev.clang or prev.stdenv.cc;
    
    baseOverride = {
      cc = ccChoice;
      bintools = moldPkg;
    };
  in
    if llvmPkgs == null then prev.stdenv
    else llvmPkgs.stdenv.override (baseOverride // (
      if llvmPkgs ? libcxx then { inherit (llvmPkgs) libcxx; }
      else { }
    ));

in
{
  # ============================================================================
  # PRIMARY: Override mkDerivation with performance flags
  # ============================================================================
  mkDerivation = args: 
    let
      existingCFlags = args.NIX_CFLAGS_COMPILE or "";
      existingLdFlags = args.NIX_LDFLAGS or "";
    in
    prev.mkDerivation (args // {
      NIX_CFLAGS_COMPILE = "${cflagsStr}${prev.lib.optionalString (existingCFlags != "") " ${existingCFlags}"}";
      NIX_LDFLAGS = "${ldflagsStr}${prev.lib.optionalString (existingLdFlags != "") " ${existingLdFlags}"}";
      
      configureFlags = (args.configureFlags or []) ++ [
        "CFLAGS=${cflagsStr}"
        "LDFLAGS=${ldflagsStr}"
      ];
    });

  # ============================================================================
  # OPTION 2: musl libc variant (smaller, faster, static binaries)
  # Uncomment to use: pkgsMusl.somePackage
  # ============================================================================
  pkgsMusl = prev.pkgsMusl.overrideScope' (selfMusl: superMusl: {
    stdenv = superMusl.stdenv.override {
      cc = superMusl.musl_clang;
      bintools = prev.mold;
    };
    # ============================================================================
    # Pinned musl version for consistency
    # ============================================================================
    musl = prev.musl_1_2_4;
  });

  # ============================================================================
  # OPTION 3: GCC with aggressive LTO
  # ============================================================================
  stdenvLTO = prev.stdenv.override {
    cc = prev.gcc13;
    extraBuildInputs = [ prev.mold ];
  };

  # ============================================================================
  # OPTION 4: Hybrid - Clang frontend with GCC backend (best compatibility)
  # ============================================================================
  stdenvClangGCC = prev.stdenv.override {
    cc = prev.clang_latest;
    bintools = prev.binutils-unwrapped;
  };

  # ============================================================================
  # OPTION 5: LTO + musl (for future use - uncomment when ready)
  # ============================================================================
  stdenvMuslLTO = prev.pkgsMusl.llvmPackages_latest.stdenv.override {
    cc = prev.pkgsMusl.llvmPackages_latest.clang;
    bintools = prev.mold;
    libcxx = prev.pkgsMusl.llvmPackages_latest.libcxx;
  };

  # ============================================================================
  # Helper function to apply performance optimizations to specific packages
  # ============================================================================
  withPerformanceOptimizations = pkg: pkg.overrideAttrs (oldAttrs: {
    NIX_CFLAGS_COMPILE = "${cflagsStr}${prev.lib.optionalString (oldAttrs.NIX_CFLAGS_COMPILE or "" != "") " ${oldAttrs.NIX_CFLAGS_COMPILE or ""}"}";
    NIX_LDFLAGS = "${ldflagsStr}${prev.lib.optionalString (oldAttrs.NIX_LDFLAGS or "" != "") " ${oldAttrs.NIX_LDFLAGS or ""}"}";
  });

  # ============================================================================
  # Use LLVM as default stdenv for best performance with modern LTO and mold
  # NOTE: Commenting out to avoid infinite recursion - apply at flake level instead
  # ============================================================================
   stdenv = llvmStdenv;
}