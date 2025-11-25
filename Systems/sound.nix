# /etc/nixos/SpidyNix/Systems/sound.nix
{ config, pkgs, lib, ... }:
{
  # Disable PulseAudio as PipeWire replaces it
  services.pulseaudio.enable = false;

  # Enable RealtimeKit for low-latency audio
  security.rtkit.enable = true;

  # PipeWire configuration
  services.pipewire = {
    enable = true;

    # --- Compatibility Layers ---
    alsa = {
      enable = true;
      # Support for 32-bit applications
      support32Bit = true;
    };

    # Enable PulseAudio compatibility
    pulse.enable = true;
    # Enable JACK compatibility
    jack.enable = true;

    # --- Low-Latency Configuration ---
    # Optimized for gaming and real-time audio
    extraConfig.pipewire = {
      "10-low-latency" = {
        "context.properties" = {
          # Set default clock rate to 48000 Hz
          "default.clock.rate" = 48000;
          # Set default quantum to 64 samples
          "default.clock.quantum" = 64;
          # Set minimum quantum to 64 samples
          "default.clock.min-quantum" = 64;
          # Set maximum quantum to 512 samples
          "default.clock.max-quantum" = 512;
        };
      };
    };
  };

  # ============================================================================
  # WIREPLUMBER CONFIGURATION
  # ============================================================================
  # WirePlumber manages audio routing and device configuration
  # ============================================================================

  services.pipewire.wireplumber = {
    enable = true;

    # Custom WirePlumber configuration
    configPackages = [
      # Bluetooth audio quality configuration
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
          -- Enable high-quality SBC codec
          ["bluez5.enable-sbc-xq"] = true,

          -- Enable mSBC codec for better call quality
          ["bluez5.enable-msbc"] = true,

          -- Enable hardware volume control
          ["bluez5.enable-hw-volume"] = true,

          -- Supported Bluetooth profiles
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",

          -- LDAC codec quality (auto/hq/sq/mq)
          ["bluez5.a2dp.ldac.quality"] = "auto",

          -- AAC bitrate mode (0 = CBR, variable bitrate modes: 1-5)
          ["bluez5.a2dp.aac.bitratemode"] = 0,

          -- Default sample rate
          ["bluez5.default.rate"] = 48000,

          -- Default channels (stereo)
          ["bluez5.default.channels"] = 2,
        }
      '')

      # Disable libcamera monitoring (causes issues on some systems)
      (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-disable-camera.lua" ''
        -- Disable camera monitoring
        alsa_monitor.enabled = true
        v4l2_monitor.enabled = false
        libcamera_monitor.enabled = false
      '')
    ];
  };

  # Enable Bluetooth for wireless audio devices
  hardware.bluetooth = {
    enable = true;

    # Use experimental Bluez for better compatibility
    package = pkgs.bluez5-experimental;

    settings = {
      General = {
        # Enable experimental features (needed for Xbox controllers, etc.)
        Experimental = true;

        # Enable faster connection
        FastConnectable = true;

        # Power on Bluetooth adapter at boot
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Disable audio processing that might cause issues
  systemd.user.services.telephony_client.enable = false;
}
# ============================================================================
# SOUND CONFIGURATION
# ============================================================================
# This file configures the audio system using PipeWire including:
#   - PipeWire (modern audio server)
#   - WirePlumber (session manager)
#   - ALSA compatibility
#   - PulseAudio compatibility
#   - JACK support
#   - Bluetooth audio
#   - Low-latency configuration
# ============================================================================
# NOTES
# ============================================================================
# PIPEWIRE:
# - Modern audio server replacing PulseAudio and JACK
# - Low latency, high quality audio
# - Per-application audio routing
# - Better Bluetooth support
# - Compatible with PulseAudio and JACK applications
#
# AUDIO CONTROL:
# - pavucontrol: Traditional PulseAudio-style GUI
# - pwvucontrol: Native PipeWire control GUI
# - Volume: Use desktop environment controls or pavucontrol
# - CLI: wpctl (WirePlumber control)
#
# WIREPLUMBER COMMANDS:
# - List devices: wpctl status
# - Set volume: wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
# - Mute: wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
# - Set default device: wpctl set-default DEVICE_ID
#
# BLUETOOTH AUDIO:
# - Connect devices: Use Blueman or bluetoothctl
# - Codecs: SBC-XQ, AAC, LDAC, aptX (hardware dependent)
# - Quality: Configured for best quality (LDAC auto)
# - Profiles: A2DP (high quality), HSP/HFP (calls)
#
# LOW-LATENCY CONFIGURATION:
# - Quantum: 512 samples (about 10ms latency at 48kHz)
# - For lower latency: Reduce quantum (e.g., 256, 128, 64)
# - Lower = less latency, more CPU usage
# - Gaming: 512 is a good balance
# - Music production: Try 128 or 64
#
# SAMPLE RATE:
# - Default: 48000 Hz (48 kHz)
# - CD quality: 44100 Hz
# - High-res: 96000 Hz or 192000 Hz
# - Most content is 48kHz, so that's the best default
#
# EASYEFFECTS:
# - System-wide audio effects
# - Equalizer, compressor, limiter, reverb, etc.
# - Presets available online
# - Launch: easyeffects
#
# TROUBLESHOOTING:
# - No sound: Check wpctl status, ensure device not muted
# - Crackling: Increase quantum size in extraConfig
# - High CPU: Increase quantum, disable effects
# - Bluetooth issues: Restart bluetooth service
# - Device not detected: Check hardware.pulseaudio.enable is false
#
# CHECKING AUDIO STATUS:
# - List devices: wpctl status
# - Check volumes: pavucontrol
# - View routing: helvum or qpwgraph
# - PipeWire status: systemctl --user status pipewire
# - WirePlumber status: systemctl --user status wireplumber
#
# RESTARTING AUDIO:
# - systemctl --user restart pipewire
# - systemctl --user restart wireplumber
# - Or reboot if persistent issues
#
# PULSEAUDIO COMPATIBILITY:
# - Most PulseAudio apps work via PipeWire's pulse module
# - Commands like pactl, pacmd work through PipeWire
# - Config in ~/.config/pulse/ still applies
#
# JACK COMPATIBILITY:
# - JACK applications work through PipeWire's JACK module
# - Lower latency than traditional JACK for most uses
# - Use qjackctl or Carla for JACK session management
#
# ALSA:
# - Direct ALSA access for low-level audio
# - Most apps use PulseAudio API via PipeWire
# - alsamixer still works for hardware controls
#
# BLUETOOTH CODEC PRIORITY:
# 1. LDAC: Best quality (Sony, Android 8+)
# 2. aptX HD: High quality (Qualcomm)
# 3. AAC: Good quality (Apple, Android)
# 4. SBC-XQ: Enhanced SBC quality
# 5. SBC: Universal fallback
#
# AUDIO LATENCY:
# - Bluetooth: ~100-200ms (codec dependent)
# - Wired: ~10ms (with quantum=512)
# - For gaming: Use wired headphones
# - For music: Bluetooth is fine
#
# MICROPHONE:
# - Built-in mics work automatically
# - Bluetooth: Use HFP/HSP profile for mic
# - USB mics: Hot-plug supported
# - Noise cancellation: Use EasyEffects
#
# ADVANCED CONFIGURATION:
# - Per-app settings: pavucontrol > Playback tab
# - Custom routing: helvum or qpwgraph
# - Filters: EasyEffects or JACK plugins
# - Pro audio: Consider dedicated JACK config
# ============================================================================
