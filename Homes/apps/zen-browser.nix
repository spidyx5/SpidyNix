# /etc/nixos/SpidyNix/Homes/apps/zen-browser.nix
{ config, pkgs, inputs, ... }:
let
  # Get system architecture for package selection
  system = pkgs.stdenv.hostPlatform.system;

  # Zen Browser package from flake input
  zenPackage = inputs.zen-browser.packages.${system}.default;

  # Override package to add dependencies and Wayland support
  zenFixed = zenPackage.overrideAttrs (old: {
    # Add required build inputs
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
      pkgs.makeWrapper
      pkgs.copyDesktopItems
      pkgs.wrapGAppsHook3
    ];

    # Add Wayland environment variable to the binary wrapper
    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/zen \
        --set MOZ_ENABLE_WAYLAND 1
    '';
  });
in
{
  # ============================================================================
  # ZEN BROWSER PACKAGE
  # ============================================================================
  home.packages = [ zenFixed ];  # Install Zen Browser with Wayland support
}
