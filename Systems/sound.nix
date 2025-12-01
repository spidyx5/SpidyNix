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
