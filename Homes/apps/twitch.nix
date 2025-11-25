# /etc/nixos/SpidyNix/Homes/apps/twitch.nix
{pkgs, ...}: {
  # ============================================================================
  # TWITCH CLIENT CONFIGURATION
  # ============================================================================
  # Twitch HLS client configuration file
  home.file.".config/twitch-hls-client/config".text = ''
    # General settings
    quality=best  # Best quality stream
    debug=false  # Disable debug mode

    # Player settings
    player=${pkgs.mpv}/bin/mpv  # Use mpv as player
    player-args=- --profile=low-latency  # Low latency profile
    quiet=true  # Quiet mode
    no-kill=false  # Don't kill player on exit

    # HLS settings
    servers=https://eu.luminous.dev/live/[channel],https://eu2.luminous.dev/live/[channel],https://as.luminous.dev/live/[channel]  # HLS servers
    print-streams=false  # Don't print streams
    no-low-latency=false  # Enable low latency
    codecs=av1,h265,h264  # Preferred codecs

    # HTTP settings
    force-https=true  # Force HTTPS
    force-ipv4=false  # Don't force IPv4
    user-agent=Mozilla/5.0 (X11; Linux x86_64; rv:143.0) Gecko/20100101 Firefox/143.0  # User agent
    http-retries=3  # HTTP retries
    http-timeout=10  # HTTP timeout
  '';

  # ============================================================================
  # TWITCH CLIENT PACKAGE
  # ============================================================================
  # Twitch HLS client as home package
  home.packages = with pkgs; [
    twitch-hls-client  # Twitch HLS client binary
  ];
}
# ============================================================================
# TWITCH CONFIGURATION
# ============================================================================
# Configures Twitch HLS client and TUI.
# ============================================================================
# NOTES:
# - This configuration sets up Twitch streaming via HLS
# - Uses mpv as the video player with low-latency profile
# - Multiple HLS servers are configured for redundancy
# - For troubleshooting:
#   - Check player logs: ~/.config/twitch-hls-client/logs/
#   - Test with: twitch-hls-client --debug
#   - Verify mpv installation: which mpv
# - To customize:
#   - Change quality setting to 'worst', 'medium', etc.
#   - Add/remove HLS servers as needed
#   - Adjust player arguments for different mpv profiles
# ============================================================================
