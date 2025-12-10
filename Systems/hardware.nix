{ pkgs, lib, ... }:

{
  nixpkgs.config.cudaSupport = false;

  hardware.enableRedistributableFirmware = true;
  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-utils
      libva
      mesa-gl-headers
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
      intel-vaapi-driver
      intel-graphics-compiler
    ];
    extraPackages32 = with pkgs; [
      intel-media-driver
      libva
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  #hardware.steam-hardware.enable = true;
  #hardware.xpadneo.enable = true;
  hardware.brillo.enable = true;

  time.hardwareClockInLocalTime = lib.mkDefault true;

  chaotic.mesa-git.enable = true;
  chaotic.mesa-git.extraPackages = with pkgs; [
    mesa_git.opencl
    intel-media-driver
    intel-ocl
    intel-vaapi-driver
  ];

  services.tuned.enable = true;
  services.tuned.settings.dynamic_tuning = true;

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    algorithm = "zstd";
    priority = 100;
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=no
    AllowHybridSleep=yes
  '';

  services.scx = {
    enable = true;
    scheduler = lib.mkForce "scx_lavd";
    # Options: scx_rusty, scx_lavd, scx_bpfland
  };

  services.thermald.enable = true;

  services.logind.settings = {
    Login = {
      HandlePowerKey = "suspend";
      HandleSuspendKey = "suspend";
      HandleHibernateKey = "yes";
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      IdleAction = "ignore";
      IdleActionSec = "30min";
    };
  };

  # ============================================================================
  # AUDIO CONFIGURATION
  # ============================================================================
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire."10-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 64;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 512;
      };
    };
  };

  services.pipewire.wireplumber = {
    enable = true;
    configPackages = [
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
          ["bluez5.a2dp.ldac.quality"] = "auto",
          ["bluez5.a2dp.aac.bitratemode"] = 0,
          ["bluez5.default.rate"] = 48000,
          ["bluez5.default.channels"] = 2,
        }
      '')
      (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-disable-camera.lua" ''
        alsa_monitor.enabled = true
        v4l2_monitor.enabled = false
        libcamera_monitor.enabled = false
      '')
    ];
  };

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.blueman.enable = true;

  systemd.user.services.telephony_client.enable = false;
}
# ZRAM DETAILS:
# - Check usage: zramctl
# - Check stats: cat /sys/block/zram0/mm_stat
# - Compression ratio: Usually 2:1 to 4:1
# - Performance: Much faster than disk swap