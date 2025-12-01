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
