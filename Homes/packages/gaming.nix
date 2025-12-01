# /etc/nixos/SpidyNix/Homes/packages/gaming.nix
{ config, lib, pkgs, ... }:

 {
  # ============================================================================
  # GAMING PACKAGES
  # ============================================================================
  # User-level gaming tools and utilities
  # ============================================================================
  home.packages = with pkgs; [
    # Vulkan and graphics optimization
    #proton-cachyos_nightly_x86_64_v3
    vulkan-volk
    vulkan-memory-allocator
    vulkan-utility-libraries
    vk-bootstrap
    vkd3d
    vkdt
    vkbasalt
    vkdevicechooser
    vulkan-extension-layer

    # Gaming overlays and tools
    mangohud              # Gaming overlay for FPS/performance
    gamescope             # Gaming compositor
    jstest-gtk            # Joystick testing tool
    antimicrox            # Controller to keyboard/mouse mapper
  ];
}
