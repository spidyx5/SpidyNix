# /etc/nixos/SpidyNix/Softwares/program.nix
{ config, pkgs, lib, inputs, ... }:
{
  # ============================================================================
  # SYSTEM PROGRAMS CONFIGURATION
  # ============================================================================
  # This file configures system-level programs using programs.* options
  # ============================================================================
  # Enable virt-manager for VM management
  programs.virt-manager.enable = true;

  # Enable ADB for Android debugging
  programs.adb.enable = true;

  # Enable chaotic-aur packages
  chaotic.mesa-git.enable = true;
  chaotic.nyx.cache.enable = true;
  chaotic.nyx.nixPath.enable = true;
  chaotic.nyx.overlay.enable = true;
  chaotic.nyx.registry.enable = true;

  # ============================================================================
  # DIRENV - DIRECTORY ENVIRONMENT MANAGER
  # ============================================================================
  # Automatically load environment variables per directory
  # ============================================================================
  programs.direnv = {
    enable = true;  # Enable direnv
    nix-direnv.enable = true;  # Enable nix-direnv integration
    silent = true;  # Disable loading messages
  };

  # ============================================================================
  # NIX-INDEX - COMMAND-NOT-FOUND DATABASE
  # ============================================================================
  # Suggests packages when command is not found
  # ============================================================================
  programs.nix-index.enable = true;

  # ============================================================================
  # FUSE - FILESYSTEM IN USERSPACE
  # ============================================================================
  # Allow non-root users to mount filesystems
  # ============================================================================
  programs.fuse.userAllowOther = true;

  # ============================================================================
  # STEAM - GAMING PLATFORM
  # ============================================================================
  # Steam gaming platform configuration
  # ============================================================================
  programs.steam = {
    enable = true;                     # Enable Steam
    remotePlay.openFirewall = true;    # Open firewall for Remote Play
    dedicatedServer.openFirewall = true;  # Open firewall for dedicated servers
    gamescopeSession.enable = true;    # Enable Gamescope session
    extraCompatPackages = with pkgs; [
      proton-ge-bin                     # Proton GE for better compatibility
    ];
  };
}
# ============================================================================
# SYSTEM PROGRAMS CONFIGURATION
# ============================================================================
# This file configures system-level programs using programs.* options
# ============================================================================
# NOTES:
# - This file configures system-wide programs
# - Programs that need system-level configuration are here
# - User-specific programs should be in Homes/*.nix
# - For troubleshooting:
#   - Check program status: systemctl status PROGRAM
#   - Verify configuration: cat /etc/nixos/configuration.nix
#   - Check logs: journalctl -u PROGRAM
# - To customize:
#   - Add/remove programs as needed
#   - Adjust program configuration
#   - Add additional program options
# ============================================================================
