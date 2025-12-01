# /etc/nixos/SpidyNix/Systems/user.nix
{ config, pkgs, lib, ... }:
{
  # Timezone - configurable via user preferences
  time.timeZone = "Asia/Singapore";
  i18n = {
    defaultLocale = "en_SG.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_SG.UTF-8";
      LC_IDENTIFICATION = "en_SG.UTF-8";
      LC_MEASUREMENT = "en_SG.UTF-8";
      LC_MONETARY = "en_SG.UTF-8";
      LC_NAME = "en_SG.UTF-8";
      LC_NUMERIC = "en_SG.UTF-8";
      LC_PAPER = "en_SG.UTF-8";
      LC_TELEPHONE = "en_SG.UTF-8";
      LC_TIME = "en_SG.UTF-8";
    };
  };
  # ============================================================================
  # Define system user accounts
  # ============================================================================
  users.users.spidy = {
    isNormalUser = true;
    description = "Spidy";

    # Home directory
    home = "/home/spidy";

    # User shell (Nushell)
    shell = pkgs.nushell;

    # User groups
    extraGroups = [
      "wheel"          # Sudo access
      "networkmanager" # Network configuration
      "audio"          # Audio devices
      "video"          # Video devices
      "input"          # Input devices
      "libvirtd"       # Virtual machine management
      "kvm"            # KVM virtualization
      "adbusers"       # Android Debug Bridge
      "plugdev"        # Pluggable devices
      "docker"         # Docker containers (if using Docker)
    ];

    # To generate: mkpasswd -m sha-512
    # Then uncomment hashedPassword and remove initialPassword
    #initialPassword = "changeme";  # CHANGE THIS ON FIRST LOGIN!
    # Once you have a hashed password, use this instead:
    # hashedPassword = "$6$rounds=656000$YOUR_HASHED_PASSWORD_HERE";
    # Alternatively, use password (plain text, less secure):
     password = "spidy";
  };

  # DEFAULT USER SHELL
  users.defaultUserShell = pkgs.nushell;

  # Keyboard layout - XKB fallback (when not using keyd)
  #services.xserver.xkb.layout = "us";
  #services.xserver.xkb.variant = "";

  # Keyd - Colemak-DH keyboard mapping (your custom settings preserved)
  services.keyd.enable = true;
  services.keyd.keyboards.default = {
    ids = [ "*" ]; # Apply to all keyboards
    settings = {
      main = {
        # Colemak-DH ortholinear mapping
        q = "q"; w = "w"; f = "f"; p = "p"; g = "g"; j = "j"; l = "l"; u = "u"; y = "y";
        a = "a"; r = "r"; s = "s"; t = "t"; d = "d"; h = "h"; n = "n"; e = "e"; i = "i"; o = "o";
        z = "z"; x = "x"; c = "c"; v = "v"; b = "b"; k = "k"; m = "m";
      };
    };
  };
   # ============================================================================
   # SUDO CONFIGURATION
   # ============================================================================
   # Configure sudo access and policies
   # ============================================================================
  security.sudo = {
    enable = true;

    # Require password for sudo (recommended for security)
    wheelNeedsPassword = true;

    # Sudo timeout (in minutes)
    extraConfig = ''
      Defaults timestamp_timeout=15
      Defaults passwd_timeout=0
    '';
    # Enable automatic login (disable for security)
    # services.displayManager.autoLogin = {
    #   enable = false;
    #   user = "spidy";
    # };
  };
}
# ============================================================================
# USER CONFIGURATION
# ============================================================================
# This file configures system users, groups, and authentication settings
# User: spidy (main user account)
# ============================================================================

# ============================================================================
# NOTES
# ============================================================================
# USER MANAGEMENT:
# - Main user: spidy
# - Home directory: /home/spidy
# - Shell: nushell
# - Sudo: Enabled via wheel group
# GROUPS EXPLAINED:
# - wheel: Sudo access (administrative privileges)
# - networkmanager: Configure network settings
# - audio: Access audio devices (speakers, microphones)
# - video: Access video devices (webcams, GPU)
# - input: Access input devices (keyboards, mice, controllers)
# - libvirtd: Manage virtual machines with libvirt
# - kvm: KVM virtualization
# - adbusers: Android Debug Bridge for Android development
# - plugdev: Access pluggable devices (USB, etc.)
# - docker: Docker container management (if Docker is enabled)
#
# ADDING NEW USERS:
# Copy the users.users.spidy block and modify:
#   users.users.newuser = {
#     isNormalUser = true;
#     description = "New User";
#     home = "/home/newuser";
#     shell = pkgs.bash;
#     extraGroups = [ "wheel" "networkmanager" ];
#     initialPassword = "changeme";
#   };
#
# CHANGING SHELLS:
# Available shells (ensure they're in environment.systemPackages):
# - pkgs.bash        - Bourne Again Shell
# - pkgs.zsh         - Z Shell
# - pkgs.fish        - Friendly Interactive Shell
# - pkgs.nushell     - Modern shell with structured data
#
# SUDO CONFIGURATION:
# - wheelNeedsPassword = true: Require password (secure)
# - wheelNeedsPassword = false: No password (convenient but risky)
# - timestamp_timeout: How long sudo remembers password (minutes)
#
# HOME MANAGER INTEGRATION:
# - User configuration is split: system (here) and home (home.nix)
# - System: User account, groups, authentication
# - Home: User environment, dotfiles, programs
# - Home Manager config: SpidyNix/Homes/home.nix
#
# TROUBLESHOOTING:
# - Can't sudo: Check if user is in wheel group
# - Can't login: Check initialPassword is set
# - Shell issues: Verify shell package is installed
# - Permission denied: Check group memberships
# - Audio not working: Ensure user in audio group
# - VM issues: Ensure user in libvirtd and kvm groups
#
# TIMEZONE:
# - Current: Asia/Singapore
# - Find yours: timedatectl list-timezones
# - Change: time.timeZone = "Your/Timezone";
#
# LOCALE:
# - Current: en_US.UTF-8
# - Available: locale -a
# - Change: i18n.defaultLocale = "your_locale";
# ============================================================================
