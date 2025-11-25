# /etc/nixos/SpidyNix/Homes/configs/xdg.nix
{ config, pkgs, lib, ... }:
let
  # Default applications
  browser = ["zen"];  # Default browser
  imageViewer = ["imv"];  # Default image viewer
  videoPlayer = ["io.github.celluloid_player.Celluloid"];  # Default video player
  audioPlayer = ["io.bassi.Amberol"];  # Default audio player

  # Helper function to create XDG associations
  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  # Image file associations
  image = xdgAssociations "image" imageViewer [
    "png" "jpg" "jpeg" "gif" "webp" "bmp" "tiff" "tif" "ico" "svg"
    "avif" "heic" "heif"
  ];

  # Video file associations
  video = xdgAssociations "video" videoPlayer [
    "mp4" "avi" "mkv" "mov" "wmv" "flv" "webm" "m4v" "3gp" "ogv"
    "ts" "mts" "m2ts"
  ];

  # Audio file associations
  audio = xdgAssociations "audio" audioPlayer [
    "mp3" "flac" "wav" "aac" "ogg" "oga" "opus" "m4a" "wma" "ape"
    "alac" "aiff"
  ];

  # Browser-related associations
  browserTypes =
    (xdgAssociations "application" browser [
      "json" "x-extension-htm" "x-extension-html" "x-extension-shtml"
      "x-extension-xht" "x-extension-xhtml"
    ])
    // (xdgAssociations "x-scheme-handler" browser [
      "about" "ftp" "http" "https" "unknown"
    ]);

  # All XDG MIME type associations
  associations = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) ({
      "application/pdf" = ["org.gnome.Papers"];  # PDF viewer
      "application/zip" = ["org.gnome.FileRoller"];  # Archive manager
      "application/x-7z-compressed" = ["org.gnome.FileRoller"];
      "application/x-rar-compressed" = ["org.gnome.FileRoller"];
      "application/x-tar" = ["org.gnome.FileRoller"];
      "application/gzip" = ["org.gnome.FileRoller"];
      "text/html" = browser;  # HTML files
      "text/plain" = ["org.gnome.TextEditor"];  # Text files
      "text/markdown" = ["org.gnome.TextEditor"];  # Markdown files
      "text/x-python" = ["org.gnome.TextEditor"];  # Python files
      "text/x-shellscript" = ["org.gnome.TextEditor"];  # Shell scripts
      "application/json" = ["org.gnome.TextEditor"];  # JSON files
      "application/xml" = ["org.gnome.TextEditor"];  # XML files
      "application/javascript" = ["org.gnome.TextEditor"];  # JavaScript files
      "text/css" = ["org.gnome.TextEditor"];  # CSS files
      "text/x-c" = ["org.gnome.TextEditor"];  # C files
      "text/x-c++" = ["org.gnome.TextEditor"];  # C++ files
      "text/x-rust" = ["org.gnome.TextEditor"];  # Rust files
      "text/x-nix" = ["org.gnome.TextEditor"];  # Nix files
      "x-scheme-handler/chrome" = ["chromium-browser"];  # Chrome handler
    }
    // image  # Image associations
    // video  # Video associations
    // audio  # Audio associations
    // browserTypes);  # Browser associations
in
{
  # ============================================================================
  # XDG BASE DIRECTORY SPECIFICATION
  # ============================================================================
  # Configure XDG directories and settings
  # ============================================================================
  xdg = {
    enable = true;  # Enable XDG configuration

    # Custom cache directory
    cacheHome = config.home.homeDirectory + "/.local/cache";

    # MIME type associations
    mimeApps = {
      enable = true;  # Enable MIME associations
      defaultApplications = associations;  # Set default applications
    };

    # User directories (Downloads, Documents, etc.)
    userDirs = {
      enable = true;  # Enable user directories
      createDirectories = true;  # Create directories if missing

      # Additional custom directories
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };

  # ============================================================================
  # XDG UTILITIES
  # ============================================================================
  # Additional packages for XDG support
  # ============================================================================
  home.packages = with pkgs; [
    # XDG utilities
    # Terminal executor for xdg-open
    (writeShellScriptBin "xdg-terminal-exec" ''
      ${pkgs.kitty}/bin/kitty "$@"
    '')
  ];
}
# ============================================================================
# XDG CONFIGURATION
# ============================================================================
# This file configures XDG directories and MIME type associations
# Home Manager module for user 'spidy'
# ============================================================================
# NOTES:
# - This configuration sets up XDG base directories and MIME associations
# - Default applications are configured for various file types
# - Custom directories are created for better organization
# - For troubleshooting:
#   - Check MIME associations: xdg-mime query default MIME_TYPE
#   - Verify XDG directories: echo $XDG_CONFIG_HOME
#   - Check default apps: xdg-settings get default-web-browser
# - To customize:
#   - Change default applications at the top of the file
#   - Add/remove MIME associations as needed
#   - Modify XDG directory locations
#   - Add custom user directories
# ============================================================================
