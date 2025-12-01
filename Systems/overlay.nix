# /etc/nixos/SpidyNix/Systems/overlay.nix (THE CORRECT FIX)
final: prev:

let
  aggressiveCFlags = [
    "-O3"
    "-march=x86-64-v3"
    "-flto=auto"
    "-fomit-frame-pointer"
    "-ffunction-sections"
    "-fdata-sections"
  ];

  aggressiveLdFlags = [
    "-fuse-ld=mold"
    "-Wl,--gc-sections"
  ];

  # Concatenate the flags for injection
  cflagsStr = prev.lib.concatStringsSep " " aggressiveCFlags;
  ldflagsStr = prev.lib.concatStringsSep " " aggressiveLdFlags;

in {
  # We override the function used to create packages (mkDerivation)
  mkDerivation = args: prev.mkDerivation (args // {
    # Append the aggressive flags to the standard environment variables
    # This ensures every package built gets these injected flags.
    NIX_CFLAGS_COMPILE = 
      (if args ? NIX_CFLAGS_COMPILE then args.NIX_CFLAGS_COMPILE else "") + " " + cflagsStr;
    
    NIX_LDFLAGS = 
      (if args ? NIX_LDFLAGS then args.NIX_LDFLAGS else "") + " " + ldflagsStr;
  });
}