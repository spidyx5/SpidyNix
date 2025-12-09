{ pkgs, lib, ... }:

{
  # Enable NetworkManager for easy network configuration
  networking.networkmanager = {
    enable = true;
    dns = "default";
    wifi.powersave = false;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  networking.nameservers = [
    "9.9.9.11"
    "149.112.112.11"
    "1.1.1.1"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 80 443 8080 59010 59011
    ];
    allowedUDPPorts = [
      59010 59011
    ];
    checkReversePath = false;
    trustedInterfaces = [
      "virbr0" "docker0" "podman0"
    ];
  };

  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = "${pkgs.networkmanager}/bin/nm-online -q";
    };
  };

  networking.nftables.enable = true;

  networking.stevenBlackHosts = {
    enableIPv6 = true;
    blockFakenews = true;
    blockGambling = true;
    blockPorn = true;
    blockSocial = true;
  };

  networking.hosts = {
    # "192.168.1.100" = [ "myserver.local" ];
  };

  networking.useDHCP = lib.mkDefault true;
  #networking.dhcpcd.enable = false;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      PubkeyAuthentication = true;
      X11Forwarding = false;
    };
  };

  # Polkit manages privilege escalation for GUI applications
  # Custom rules allow wheel group convenience without passwords
  security.polkit = {
    enable = true;

    extraConfig = ''
      /* Allow wheel group to manage systemd units without password */
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });

      /* Allow wheel group to mount drives without password */
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.udisks2.filesystem-mount-system" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };

  # ============================================================================
  # APPARMOR - MANDATORY ACCESS CONTROL
  # ============================================================================
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
    packages = [ pkgs.apparmor-profiles ];
  };

  # ============================================================================
  # KERNEL HARDENING
  # ============================================================================
  security = {
    protectKernelImage = false;
    allowUserNamespaces = true;
    allowSimultaneousMultithreading = true;
  };

  # ============================================================================
  # PAM - LOGIN LIMITS (Critical for gaming/Wine)
  # ============================================================================
  security.pam = {
    loginLimits = [
      { domain = "*"; type = "soft"; item = "nofile"; value = "524288"; }
      { domain = "*"; type = "hard"; item = "nofile"; value = "1048576"; }
    ];
  };

  # ============================================================================
  # DBUS - HIGH PERFORMANCE MESSAGE BROKER
  # ============================================================================
  services.dbus = {
    enable = true;
    implementation = "broker";
    packages = [ pkgs.dconf ];
  };

  # ============================================================================
  # X SERVER - DISABLED (Using Wayland)
  # ============================================================================
  services.xserver.enable = false;

  # ============================================================================
  # LVM - LOGICAL VOLUME MANAGEMENT
  # ============================================================================
  services.lvm = {
    enable = true;
    boot.thin.enable = true;
  };

  boot.initrd.services.lvm.enable = true;

  # ============================================================================
  # FLATPAK - SANDBOXED APPLICATIONS
  # ============================================================================
  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # ============================================================================
  # MUSNIX - MUSIC/AUDIO PRODUCTION
  # ============================================================================
  #musnix.enable = true;
  #musnix.kernel.realtime = true;

  # ============================================================================
  # FSTRIM - SSD OPTIMIZATION
  # ============================================================================
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # ============================================================================
  # SYSTEMD OOM DAEMON
  # ============================================================================
  systemd.oomd.enable = false;

  # ============================================================================
  # CACHIX & COMPRESSION
  # ============================================================================
  services.cachix-watch-store.compressionLevel = 5;
  hardware.firmwareCompression = "zstd";
  services.nginx.experimentalZstdSettings = true;

  # ============================================================================
  # EARLYOOM - OUT-OF-MEMORY HANDLER
  # ============================================================================
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;

    extraArgs = [
      "--prefer" "(^|/)(java|chromium|firefox|zen|chrome|electron|code)$"
      "--avoid" "(^|/)(steam|gamescope|Xwayland|kwin_wayland|Hyprland|niri)$"
    ];
  };

  # ============================================================================
  # LIBINPUT - INPUT DEVICE HANDLING
  # ============================================================================
  services.libinput = {
    enable = true;

    touchpad = {
      tapping = true;
      naturalScrolling = true;
      middleEmulation = true;
      disableWhileTyping = true;
    };
  };

  # ============================================================================
  # TUMBLER - THUMBNAIL GENERATION
  # ============================================================================
  services.tumbler.enable = true;

  # ============================================================================
  # FWUPD - FIRMWARE UPDATE DAEMON
  # ============================================================================
  services.fwupd.enable = true;

  services.gvfs.enable = true;
  # ============================================================================
  # UDEV RULES - GAME CONTROLLERS & DEVICES
  # ============================================================================
  services.udev.extraRules = ''
    # =========================================================================
    # NINTENDO CONTROLLERS
    # =========================================================================

    # Nintendo Switch Pro Controller over USB
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666", TAG+="uaccess"

    # Nintendo Switch Pro Controller over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0666", TAG+="uaccess"

    # Nintendo Switch Joy-Cons (Left)
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2006", MODE="0666", TAG+="uaccess"

    # Nintendo Switch Joy-Cons (Right)
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2007", MODE="0666", TAG+="uaccess"

    # =========================================================================
    # XBOX CONTROLLERS
    # =========================================================================

    # Xbox 360 Controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", MODE="0666", TAG+="uaccess"

    # Xbox One Controller (multiple variants)
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02d1", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02dd", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02e0", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02ea", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b00", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b05", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b12", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b13", MODE="0666", TAG+="uaccess"

    # Xbox Series X|S Controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b20", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b21", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b22", MODE="0666", TAG+="uaccess"

    # =========================================================================
    # PLAYSTATION CONTROLLERS
    # =========================================================================

    # PlayStation 4 DualShock 4
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666", TAG+="uaccess"

    # PlayStation 5 DualSense
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666", TAG+="uaccess"

    # =========================================================================
    # OTHER CONTROLLERS
    # =========================================================================

    # Flydigi Vader 4 Pro Controller (dinput mode)
    KERNEL=="hidraw*", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", ENV{ID_INPUT_JOYSTICK}=="1", TAG+="steam-controller"
    SUBSYSTEM=="input", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", ENV{ID_INPUT_JOYSTICK}=="1", ENV{STEAM_INPUT_ENABLE}="1"
    SUBSYSTEM=="input", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", ENV{ID_INPUT_JOYSTICK}=="1", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/input/event%n"

    # 8BitDo Ultimate 2 (2.4GHz/Dongle and Bluetooth)
    KERNEL=="hidraw*", ATTRS{idProduct}=="6012", ATTRS{idVendor}=="2dc8", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="2DC8:6012", MODE="0660", TAG+="uaccess"

    # =========================================================================
    # GENERIC GAME CONTROLLER RULES
    # =========================================================================

    # Generic rule for all game controllers
    SUBSYSTEM=="input", ATTRS{name}=="*Controller*", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{name}=="*Gamepad*", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{name}=="*Joy-Con*", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{name}=="*Joystick*", MODE="0666", TAG+="uaccess"

    # =========================================================================
    # ANDROID DEBUG BRIDGE (ADB)
    # =========================================================================

    # Generic Android devices for ADB
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="adbusers"

    # =========================================================================
    # HARDWARE BRIGHTNESS CONTROL
    # =========================================================================

    # Allow users in video group to change backlight brightness
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="*", RUN+="${pkgs.coreutils}/bin/chmod 666 /sys/class/backlight/%k/brightness"
  '';

  # ============================================================================
  # DCONF - GSETTINGS CONFIGURATION STORAGE
  # ============================================================================
  programs.dconf.enable = true;

  # ============================================================================
  # GEOLOCATION SERVICES
  # ============================================================================
  # Provides location data for applications (Gammastep, Redshift, etc.)
  # ============================================================================

  location.provider = "geoclue2";

  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://beacondb.net/v1/geolocate";
    submissionUrl = "https://beacondb.net/v2/geosubmit";
    submissionNick = "geoclue";

    appConfig = {
      gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };

  # ============================================================================
  # OPTIONAL: QEMU GUEST (uncomment if running in VM)
  # ============================================================================
  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;
  # services.spice-webdavd.enable = true;
  systemd.user.services.niri-flake-polkit.enable = false;
}
