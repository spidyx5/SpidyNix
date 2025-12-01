# /etc/nixos/SpidyNix/Systems/overlay.nix
final: prev:

let
  # The compiler flags for NIX_CFLAGS_COMPILE
  aggressiveCFlags = [
    "-O3"
    "-march=x86-64-v3" # Adjust if your target machine is not v3 compatible
    "-flto=auto"
    "-fomit-frame-pointer"
    "-ffunction-sections"
    "-fdata-sections"
  ];

  # The linker flags for NIX_LDFLAGS
  aggressiveLdFlags = [
    "-fuse-ld=mold"
    "-Wl,--gc-sections"
  ];

in {
  # Override the default stdenv package set
  stdenv = prev.stdenv.override {
    initialBuildFlags = {
      # Concatenate the flag lists into space-separated strings
      NIX_CFLAGS_COMPILE = prev.lib.concatStringsSep " " aggressiveCFlags;
      NIX_LDFLAGS = prev.lib.concatStringsSep " " aggressiveLdFlags;
    };
  };
}