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
# ============================================================================
# ZEN BROWSER CONFIGURATION
# ============================================================================
# Configures Zen Browser with Wayland support
# Home Manager module for user 'spidy'
# ============================================================================
# NOTES:
# - Zen Browser is a privacy-focused Firefox fork
# - Wayland support is enabled via MOZ_ENABLE_WAYLAND=1
# - Includes vertical tabs and split view by default
# - For troubleshooting:
#   - Check Wayland support: echo $MOZ_ENABLE_WAYLAND
#   - Verify installation: which zen
#   - Check browser version: zen --version
# - To customize:
#   - Add Firefox extensions for additional functionality
#   - Change privacy settings in about:config
#   - Adjust theme and appearance settings
# ============================================================================
