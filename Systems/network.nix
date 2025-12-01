# /etc/nixos/SpidyNix/Systems/network.nix
{ config, pkgs, lib, ... }:
{
  # Core networking configuration
  # Enable NetworkManager for easy network configuration
  networking.networkmanager = {
    enable = true;

    # DNS configuration
    dns = "default";  # Use system DNS resolver

    # WiFi power saving (disable for better performance)
    wifi.powersave = false;

    # Plugins for additional functionality
    plugins = with pkgs; [
      networkmanager-openvpn  # VPN support
    ];
  };

  # ============================================================================
  # DNS CONFIGURATION
  # ============================================================================
  # Configure DNS servers for privacy and performance
  # ============================================================================

  networking.nameservers = [
    "9.9.9.11"
    "149.112.112.11"     
    "1.1.1.1"      
  ];

  # ============================================================================
  # FIREWALL CONFIGURATION
  # ============================================================================
  # Configure firewall rules and allowed ports
  # ============================================================================

  networking.firewall = {
    enable = true;

    # Allowed TCP ports
    allowedTCPPorts = [
      22      # SSH
      80      # HTTP
      443     # HTTPS
      8080    # Alternative HTTP
      59010   # Custom application
      59011   # Custom application
    ];

    # Allowed UDP ports
    allowedUDPPorts = [
      59010   # Custom application
      59011   # Custom application
    ];
  };

  # ============================================================================
  # NETWORK OPTIMIZATION
  # ============================================================================
  # Kernel parameters for network performance (sysctl)
  # These are in addition to those in boot.nix
  # ============================================================================

  boot.kernel.sysctl = {
    # --- Network Buffers ---
    "net.core.rmem_default" = 262144;               # Default receive buffer
    "net.core.wmem_default" = 262144;               # Default send buffer

    # --- TCP Buffers ---
    "net.ipv4.tcp_rmem" = "4096 131072 134217728";  # TCP receive buffer
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";   # TCP send buffer

    "net.ipv4.tcp_low_latency" = 1;                 # Low latency mode
    # --- IPv4 Forwarding (for VMs/containers) ---
    "net.ipv4.ip_forward" = 1;                      # Enable IP forwarding
    # --- Network Performance ---
    "net.core.rmem_max" = 16777216;          # Max receive buffer
    "net.core.wmem_max" = 16777216;          # Max send buffer
    "net.core.netdev_budget" = lib.mkForce 600;          # Network processing budget
    "net.core.netdev_max_backlog" = 16384;   # Network device backlog
    "net.core.default_qdisc" = lib.mkForce "cake";       # Default qdisc (bufferbloat)
    "net.core.bpf_jit_harden" = 2;           # Harden BPF JIT

    # --- TCP Optimizations ---
    "net.ipv4.tcp_congestion_control" = "bbr";        # BBR congestion control
    "net.ipv4.tcp_fastopen" = 3;                      # TCP Fast Open
    "net.ipv4.tcp_no_metrics_save" = 1;               # Don't save metrics
    "net.ipv4.tcp_moderate_rcvbuf" = 1;               # Auto-tune receive buffer
    "net.ipv4.tcp_window_scaling" = 1;                # TCP window scaling
    "net.ipv4.tcp_timestamps" = 1;                    # TCP timestamps
    "net.ipv4.tcp_sack" = lib.mkForce 1;                          # Selective ACK
    "net.ipv4.tcp_fin_timeout" = lib.mkForce 15;                  # Reduce TIME_WAIT
    "net.ipv4.tcp_tw_reuse" = 1;                      # Reuse TIME_WAIT sockets
    "net.ipv4.tcp_rfc1337" = lib.mkForce 1;                       # TIME-WAIT assassination protection
    "net.ipv4.tcp_syncookies" = 1;                    # SYN flood protection

    # --- Network Security ---
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1; # Ignore bogus ICMP
    "net.ipv4.conf.default.rp_filter" = 1;            # Reverse path filtering
    "net.ipv4.conf.all.rp_filter" = 1;                # Reverse path filtering
    "net.ipv4.conf.all.accept_source_route" = 0;      # No source routing
    "net.ipv6.conf.all.accept_source_route" = 0;      # No source routing (IPv6)
    "net.ipv4.conf.all.send_redirects" = 0;           # Don't send redirects
    "net.ipv4.conf.default.send_redirects" = 0;       # Don't send redirects
    "net.ipv4.conf.all.accept_redirects" = 0;         # Don't accept redirects
    "net.ipv4.conf.default.accept_redirects" = 0;     # Don't accept redirects
    "net.ipv4.conf.all.secure_redirects" = 0;         # No secure redirects
    "net.ipv4.conf.default.secure_redirects" = 0;     # No secure redirects
    "net.ipv6.conf.all.accept_redirects" = 0;         # Don't accept redirects (IPv6)
    "net.ipv6.conf.default.accept_redirects" = 0;     # Don't accept redirects (IPv6)
  };

  # Load BBR module
  boot.kernelModules = [ "tcp_bbr" ];

  # Enable SSH for remote access
  # ============================================================================

  #services.openssh = {
  #  enable = true;

   # settings = {
      # Disable root login for security
   #   PermitRootLogin = "no";

      # Disable password authentication (use SSH keys only)
   #   PasswordAuthentication = false;

      # Enable public key authentication
    #  PubkeyAuthentication = true;

      # Disable X11 forwarding
    #  X11Forwarding = false;
   # };
  #};

  # ============================================================================
  # SYSTEMD NETWORK SERVICES
  # ============================================================================
  # Optimize systemd network services
  # ============================================================================

  # Speed up NetworkManager-wait-online service
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
    };
  };

  # ============================================================================
  # NFTABLES
  # ============================================================================
  # Use nftables instead of iptables (more modern)
  # ============================================================================

  networking.nftables.enable = true;

  networking.stevenBlackHosts = {
    enableIPv6 = true;
    blockFakenews = true;
    blockGambling = true;
    blockPorn = true;
    blockSocial = true;
  };

  # ============================================================================
  # VIRTUALIZATION FIREWALL CONFIGURATION
  # ============================================================================
  # Firewall settings for virtualization tools
  # ============================================================================

  # Allow libvirt to create firewall rules
  networking.firewall.checkReversePath = false;

  # Trusted interfaces for VM/container networking
  networking.firewall.trustedInterfaces =  [
   "virbr0" "docker0"  "podman0"  ];
  # ============================================================================
  # NETWORK MANAGER FEATURES
  # ============================================================================
  # Additional NetworkManager configuration
  # ============================================================================

  # Use DHCP by default
 # networking.useDHCP = lib.mkDefault true;

  # Disable dhcpcd (we're using NetworkManager)
  #networking.dhcpcd.enable = false;

  # ============================================================================
  # HOSTS FILE
  # ============================================================================
  # Manage /etc/hosts
  # ============================================================================

  # Enable hosts file management
  networking.hosts = {
    # Add custom host entries here if needed
    # "192.168.1.100" = [ "myserver.local" ];
  };
}
# ============================================================================
# NETWORK CONFIGURATION
# ============================================================================
# This file configures network settings including:
#   - NetworkManager (WiFi and Ethernet management)
#   - Firewall rules and ports
#   - DNS configuration
#   - Network performance optimizations
#   - SSH access
# ============================================================================
# NOTES
# ============================================================================
# NETWORKMANAGER USAGE:
# - GUI: Use nm-applet or KDE/GNOME network settings
# - CLI: nmcli or nmtui
# - Connect to WiFi: nmcli device wifi connect SSID password PASSWORD
# - List connections: nmcli connection show
# - Disconnect: nmcli connection down CONNECTION
#
# FIREWALL:
# - Enabled by default for security
# - Add ports in allowedTCPPorts/allowedUDPPorts
# - Check status: sudo iptables -L
# - Temporarily disable: sudo systemctl stop firewall
#
# DNS:
# - Using Cloudflare (1.1.1.1) for privacy
# - Google DNS (8.8.8.8) as fallback
# - Check current DNS: resolvectl status
# - Test DNS: nslookup example.com
#
# SSH ACCESS:
# - Enabled for remote access
# - Root login disabled (security)
# - Password authentication disabled (use SSH keys)
# - Generate key: ssh-keygen -t ed25519
# - Copy key: ssh-copy-id user@host
# - Connect: ssh user@host
#
# NETWORK PERFORMANCE:
# - BBR: Better congestion control
# - CAKE: Reduces bufferbloat
# - TCP Fast Open: Reduces latency
# - Large buffers: Better throughput
#
# VPN SUPPORT:
# - OpenVPN plugin included
# - WireGuard: Add wireguard-tools to systemPackages
# - Configure via NetworkManager GUI/CLI
#
# TROUBLESHOOTING:
# - No internet: sudo systemctl restart NetworkManager
# - WiFi not working: nmcli radio wifi on
# - DNS issues: resolvectl flush-caches
# - Firewall blocking: Check sudo iptables -L
# - Connection issues: journalctl -u NetworkManager
#
# STEAM REMOTE PLAY:
# - Ports 27031-27036 (UDP)
# - Ports 27036-27037 (TCP)
# - Configured in extraCommands
#
# KDE CONNECT:
# - Ports 1714-1764 (TCP/UDP)
# - For phone-PC integration
# - Configured in extraCommands
#
# SECURITY HARDENING:
# - Source routing disabled (prevents IP spoofing)
# - ICMP redirects disabled (prevents MITM)
# - SYN cookies enabled (SYN flood protection)
# - Reverse path filtering (validates packet sources)
#
# PERFORMANCE TUNING:
# - TCP window scaling: Better throughput on high-latency links
# - Selective ACK: Recovers from packet loss faster
# - Low latency mode: Reduces latency for interactive traffic
# - BBR: Modern congestion control algorithm
#
# NFTABLES:
# - Modern replacement for iptables
# - Better performance and syntax
# - Enabled by default in this config
# ============================================================================
