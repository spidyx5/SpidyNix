# /etc/nixos/SpidyNix/Systems/service.nix
{ config, pkgs, lib, ... }:
{
  # Disable X server (we're using Wayland)
  services.xserver.enable = false;

  # Enable OpenSSH for remote access
  #services.openssh.enable = true;

  # Enable Blueman for Bluetooth management
  services.blueman.enable = true;
   services.sysc-greet = {
    enable = true;
    compositor = "niri"; 
  };
  # Enable Flatpak for containerized applications
  services.flatpak.enable = true;
  # Add Flathub repository
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # Enable Musnix for music production
  musnix.enable = true;
  musnix.kernel.realtime = false;  # Disable realtime kernel

  # Enable fstrim for SSD optimization
  services.fstrim = {
    enable = true;
    interval = "weekly";  # Run weekly
  };

  # Disable systemd OOM daemon
  systemd.oomd.enable = false;
  
  services.cachix-watch-store.compressionLevel = 5;
  hardware.firmwareCompression = "zstd";
  services.nginx.experimentalZstdSettings = true;
  # Enable EarlyOOM for out-of-memory handling
  services.earlyoom = {
    enable = true;
    enableNotifications = true;  # Show notifications when processes are killed

    # Kill something if RAM goes below 5% or Swap below 5%
    freeMemThreshold = 5;
    freeSwapThreshold = 5;

    # Prefer killing browsers and Electron apps
    extraArgs = [
      "--prefer" "(^|/)(java|chromium|firefox|zen|chrome|electron|code)$"

      # Avoid killing Steam, Gamescope, Wayland, X11
      "--avoid" "(^|/)(steam|gamescope|Xwayland|kwin_wayland|Hyprland|niri)$"
    ];
  };

  # ============================================================================
  # LIBINPUT
  # ============================================================================
  # Input device management (touchpad, mouse, keyboard)
  # ============================================================================

  services.libinput = {
    enable = true;

    # Touchpad configuration
    touchpad = {
      tapping = true;  # Enable tap-to-click
      naturalScrolling = true;  # Enable natural scrolling
      middleEmulation = true;  # Enable middle-click emulation
      disableWhileTyping = true;  # Disable touchpad while typing
    };
  };

  # Enable GNOME Virtual File System (for mounting USB drives, etc.)
  #services.gvfs.enable = true;

  # ============================================================================
  # TUMBLER
  # ============================================================================
  # Thumbnail generator for images and videos
  # ============================================================================

  services.tumbler.enable = true;

  # Enable firmware update daemon
  services.fwupd.enable = true;

  # Enable automatic nice daemon for better process priority management
 # services.ananicy = {
 #   enable = true;
  #  package = pkgs.ananicy-cpp;  # Use the C++ version
 # };

  # ============================================================================
  # UDEV RULES
  # ============================================================================
  # Device rules for game controllers and hardware
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
  # DCONF
  # ============================================================================
  # Configuration system used by many applications
  # ============================================================================

  programs.dconf.enable = true;

  # ============================================================================
  # VIRTUAL MACHINE SERVICES
  # ============================================================================
  # QEMU guest agent services (useful if running as a VM)
  # ============================================================================

  # Uncomment if running NixOS as a virtual machine guest
  #services.qemuGuest.enable = true;
  #services.spice-vdagentd.enable = true;
  #services.spice-webdavd.enable = true;

  # ============================================================================
  # LOCATION SERVICES
  # ============================================================================
  # Geolocation for applications that need it (e.g., Gammastep, Redshift)
  # ============================================================================

  location.provider = "geoclue2";  # Use geoclue2 for location services

  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://beacondb.net/v1/geolocate";  # URL for geolocation
    submissionUrl = "https://beacondb.net/v2/geosubmit";   # URL for location submission
    submissionNick = "geoclue";                           # Nickname for submissions

    # Allow specific apps to access location
    appConfig = {
      gammastep = {
        isAllowed = true;  # Allow Gammastep to access location
        isSystem = false;  # Not a system service
      };
    };
  };
}
