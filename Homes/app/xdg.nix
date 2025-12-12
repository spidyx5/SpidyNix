{ config, pkgs, lib, inputs, ... }:

let
  # Default applications
  browser = [ "zen" ];
  imageViewer = [ "imv" ];
  videoPlayer = [ "io.github.celluloid_player.Celluloid" ];
  audioPlayer = [ "io.bassi.Amberol" ];
  textEditor = [ "kate" ];
  fileManager = [ "org.kde.dolphin" ];

  # Helper function to create XDG associations
  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
      name = "${type}/${e}";
      value = program;
    }) list);

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
    "application/pdf" = [ "org.gnome.Papers" ];
    "application/zip" = fileManager;
    "application/x-7z-compressed" = fileManager;
    "application/x-rar-compressed" = fileManager;
    "application/x-tar" = fileManager;
    "application/gzip" = fileManager;
    "text/html" = browser;
    "text/plain" = textEditor;
    "text/markdown" = textEditor;
    "text/x-python" = textEditor;
    "text/x-shellscript" = textEditor;
    "application/json" = textEditor;
    "application/xml" = textEditor;
    "application/javascript" = textEditor;
    "text/css" = textEditor;
    "text/x-c" = textEditor;
    "text/x-c++" = textEditor;
    "text/x-rust" = textEditor;
    "text/x-nix" = textEditor;
    "x-scheme-handler/chrome" = [ "chromium-browser" ];
  }
  // image
  // video
  // audio
  // browserTypes);
in
{
  # =========================================================================
  # XDG BASE DIRECTORY SPECIFICATION
  # =========================================================================
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };

  # =========================================================================
  # XDG UTILITIES
  # =========================================================================
  home.packages = with pkgs; [
    (writeShellScriptBin "xdg-terminal-exec" ''
      ${pkgs.ghostty}/bin/ghostty "$@"
    '')
  ];
}
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
