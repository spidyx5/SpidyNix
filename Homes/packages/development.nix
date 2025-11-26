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
    rust-analyzer         # Rust LSP
    nodePackages.bash-language-server  # Bash LSP

    # Formatters & linters
    nixpkgs-fmt           # Nix formatter
    rustfmt               # Rust formatter
    nodePackages.prettier # Multi-language formatter
    shellcheck            # Shell script linter
    shfmt                 # Bash formatter

    # Code tools
    tree-sitter           # Required by treesitter
    yaml-language-server
    marksman              # Markdown language server

    # Runtime environments
    python3               # Python runtime
    python3Packages.pip
    nodejs
    nodePackages.npm

    # Build systems
    gnumake               # GNU Make
    ninja
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
    ripgrep               # Fast grep alternative
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