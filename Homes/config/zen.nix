{ config, pkgs, inputs, ... }:

let
  # Get system architecture for package selection
  system = pkgs.stdenv.hostPlatform.system;

  # Zen Browser package from flake input
  zenPackage = inputs.zen-browser.packages.${system}.default;

  # Override package to add dependencies and Wayland support
  zenFixed = zenPackage.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
      pkgs.makeWrapper
      pkgs.copyDesktopItems
      pkgs.wrapGAppsHook3
    ];

    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/zen \
        --set MOZ_ENABLE_WAYLAND 1
    '';
  });
in
{
  # =========================================================================
  # ZEN BROWSER PACKAGE
  # =========================================================================
  home.packages = [ zenFixed ];
}
