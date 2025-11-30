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
    proton-cachyos_x86_64_v3
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
# ============================================================================
# GAMING CONFIGURATION
# ============================================================================
# This file configures user-level gaming tools and utilities
# Home Manager module for user 'spidy'
# ============================================================================
# NOTES:
# - This configuration provides gaming tools when myConfig.gaming is enabled
# - Includes Vulkan optimizations and gaming overlays
# - Tools are installed per-user, not system-wide
# - For troubleshooting:
#   - Check tool installation: which mangohud
#   - Verify Vulkan: vulkaninfo
# - To customize:
#   - Add/remove gaming tools as needed
#   - Configure overlays in tool-specific config files
# ============================================================================
