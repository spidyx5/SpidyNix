# /etc/nixos/SpidyNix/Homes/packages/development.nix
{ config, lib, pkgs, ... }:

{
  # ============================================================================
  # DEVELOPMENT TOOLS
  # ============================================================================
  # User-level development tools and programming languages
  # ============================================================================
  home.packages = with pkgs; [
    # ==========================================================================
    # DEVELOPMENT TOOLS
    # ==========================================================================
    # Language servers (CLI tools)
    nixd                  # Fast Nix LSP


    # Runtime environments
    python315               # Python runtime
    python313Packages.pip
    nodejs
    #nodePackages.npm

    # Build systems
    meson
    cmake
    binutils
    libtool               # libtool replacement
    samurai               # Ninja replacement

    # Shell enhancements
    zoxide                # Smarter cd command
    carapace              # Multi-shell completion
    inshellisense         # IDE-like shell completions
    fzf                   # Fuzzy finder
        # VM management
    virt-viewer           # Virtual machine viewer
    virt-top              # Monitor VM performance
    looking-glass-client  # Low-latency VM display (includes host)
    scream

    # QEMU/KVM
    OVMF                  # UEFI firmware for VMs
    swtpm                 # TPM emulation
    libguestfs            # VM disk tools
    freerdp

    # SPICE support
    spice                 # SPICE protocol support
    spice-gtk             # SPICE client GTK
    spice-protocol        # SPICE protocol headers
    virglrenderer         # Virtual GPU support
    virtio-win
    spice-vdagent
    spice-autorandr
  ];
}
# ============================================================================
# DEVELOPMENT PACKAGES CONFIGURATION
# ============================================================================
# This file contains user-level development tools and programming languages
# Home Manager module for user 'spidy'
# ============================================================================
# NOTES:
# - This configuration provides development tools and programming languages
# - Includes language servers, formatters, build systems, and runtime environments
# - Tools are installed per-user, not system-wide
# - For troubleshooting:
#   - Check tool installation: which TOOL_NAME
#   - Verify language installations: python3 --version, node --version
# - To customize:
#   - Add/remove development tools as needed
# ============================================================================