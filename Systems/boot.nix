{ pkgs, lib, config, ... }:

{
  boot.loader = {
    limine = {
      enable = true;
      efiSupport = true;
      style.wallpapers = [ ./Spidy/wallpaper/chillbill.jpg ];
      maxGenerations = 10;
      #secureBoot.enable = true;
    };
    systemd-boot.enable = lib.mkForce false;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackages_cachyos-lto.override {
    stdenv = pkgs.llvmStdenv or pkgs.llvmPackages_latest.stdenv;
  });

  specialisation = {
    lqx-kernel.configuration = {
      boot.kernelPackages = pkgs.linuxPackages_lqx;
    };
    xanmod-kernel.configuration = {
      boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    };
    rt-kernel.configuration = {
      boot.kernelPackages = pkgs."linuxPackages-rt_latest";
    };
  };

  boot.kernelParams = [
    # --- Performance Optimizations ---
    "nvme_core.default_ps_max_latency_us=0"  # NVMe max performance
    "zswap.enabled=1"                        # Enable zswap compression
    "mitigations=off"                        # Disable CPU mitigations (performance over security)
    "rootflags=noatime"                      # Disable access time updates
    "nowatchdog"                             # Disable watchdog entirely
    "threadirqs"                             # Use threaded interrupts for lower latency
    "kernel.split_lock_mitigate=0"           # Crucial for gaming (prevents fps drops)

    # --- Security Hardening ---
    "init_on_alloc=1"                        # Initialize allocated memory
    "init_on_free=1"                         # Initialize freed memory
    "randomize_kstack_offset=on"             # Randomize kernel stack offset
    "vsyscall=none"                          # Disable legacy vsyscall
    "slab_nomerge"                           # Prevent SLAB merging
    "page_alloc.shuffle=1"                   # Randomize page allocator

    # --- LSM Stack ---
    "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"  # Loadable Security Modules

    # --- Boot Debugging ---
    "quiet"                                  # Quiet boot (remove for debugging)
    "plymouth.use-simpledrm"
    "acpi_sleep_default=deep"
    "acpi_sleep=nonvs"
    "mem_sleep_default=deep"
    "resume=/dev/mapper/mock-fang"
    "intel_idle.max_cstate=4"                # Intel CPU C-state limit
    "intel_pstate=passive"                   # Intel P-state passive mode
    "intel_iommu=on"                         # Enable Intel IOMMU
    "i915.enable_gvt=1"                      # Enable Intel GVT-g
    "kvm-intel.nested=0"                     # Disable nested virtualization
    "iommu=pt"                               # Enable IOMMU passthrough
  ];

  boot.kernelModules = [
    "kvm"
    "v4l2loopback"   # Virtual video device (for OBS)
    "i2c-dev"        # I2C device support
    "efivarfs"       # EFI variable filesystem
    "uinput"         # User input device
    "tcp_bbr"        # BBR congestion control
    "hid_nintendo"   # Nintendo Switch controllers
    "xpad"           # Xbox controllers
    # Networking
    "tun"            # TUN/TAP devices for VM networking
    "vhost_net"      # Vhost-net for better network performance
    "vfio_virqfd"
    "kvm-intel"      # Intel KVM virtualization
    "i915"           # Intel graphics
    "kvmgt"          # Intel GVT-g mediated devices
    "btrfs"          # Btrfs filesystem
    "dm-snapshot"    # Device mapper snapshots
    "dm-mod"         # Device mapper core
    "dm-thin-pool"   # Thin pool logical volume
    "dm-mirror"      # General LVM support
     #"vfio_pci"
     #"vfio"
     #"vfio_iommu_type1"
     #"dm-crypt"
  ];

  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"     # USB 3.0 controller
      "ahci"         # SATA controller
      "nvme"         # NVMe drives
      "usbhid"       # USB HID devices
      "usb_storage"  # USB storage
      "sd_mod"       # SCSI disk support
    ];
  };

  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback  # v4l2loopback module
  ];

  # ============================================================================
  # KERNEL MODULE OPTIONS
  # ============================================================================
  boot.extraModprobeConfig = ''
    # v4l2loopback for OBS virtual camera
    options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Output"

    # RTW88 wireless driver optimizations
    options rtw88_core disable_lps_deep=y
    options rtw88_pci disable_aspm=y

    # Bluetooth stability fix
    options bluetooth disable_ertm=1
    options vfio-pci ids=8086:56a1:8086:4f90
  '';

  # ============================================================================
  # SYSCTL - KERNEL RUNTIME PARAMETERS
  # ============================================================================
  boot.kernel.sysctl = {
    # --- Memory Management ---
    "vm.swappiness" = lib.mkDefault 100;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.watermark_scale_factor" = 200;
    "vm.overcommit_memory" = 1;
    "vm.max_map_count" = lib.mkForce 2147483642;
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_rnd_compat_bits" = 16;
    "vm.unprivileged_userfaultfd" = 0;

    # --- Kernel Security ---
    "kernel.sysrq" = 0;
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.nmi_watchdog" = 0;
    "kernel.core_uses_pid" = 1;
    "kernel.randomize_va_space" = 2;

    # --- Filesystem Security ---
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = 0;

    # --- TTY Security ---
    "dev.tty.ldisc_autoload" = 0;

    # --- Network Buffers ---
    "net.core.rmem_default" = 262144;
    "net.core.wmem_default" = 262144;

    # --- TCP Buffers ---
    "net.ipv4.tcp_rmem" = "4096 131072 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
    "net.ipv4.tcp_low_latency" = 1;

    # --- IPv4 Forwarding ---
    "net.ipv4.ip_forward" = 1;

    # --- Network Performance ---
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.core.netdev_budget" = lib.mkForce 600;
    "net.core.netdev_max_backlog" = 16384;
    "net.core.default_qdisc" = lib.mkForce "cake";
    "net.core.bpf_jit_harden" = 2;

    # --- TCP Optimizations ---
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_no_metrics_save" = 1;
    "net.ipv4.tcp_moderate_rcvbuf" = 1;
    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_sack" = lib.mkForce 1;
    "net.ipv4.tcp_fin_timeout" = lib.mkForce 15;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_rfc1337" = lib.mkForce 1;
    "net.ipv4.tcp_syncookies" = 1;

    # --- Network Security ---
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  boot.blacklistedKernelModules = [
    # ============================================================================
    # OBSCURE NETWORK PROTOCOLS
    # ============================================================================
    "af_802154" "appletalk" "atm" "ax25" "decnet" "econet" "ipx" "n-hdlc"
    "netrom" "p8022" "p8023" "psnap" "rds" "rose" "tipc" "x25"

    # ============================================================================
    # OLD/RARE FILESYSTEMS
    # ============================================================================
    "adfs" "affs" "befs" "bfs" "cramfs" "efs" "erofs" "exofs" "f2fs"
    "freevxfs" "gfs2" "hfs" "hfsplus" "hpfs" "jffs2" "jfs" "ksmbd"
    "minix" "nilfs2" "omfs" "qnx4" "qnx6" "squashfs" "sysv" "udf"

    # ============================================================================
    # SECURITY-SENSITIVE MODULES
    # ============================================================================
    "firewire-core" "thunderbolt" "vivid"

    # ============================================================================
    # ADDITIONAL MODULES
    # ============================================================================
    "pcspkr" "snd_pcsp" "iTCO_wdt" "nouveau" "radeon"
  ];

  systemd.coredump.extraConfig = ''
    Storage=none
    ProcessSizeMax=0
  '';

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 spidy kvm -"
  ];

  boot.tmp = {
    useTmpfs = true;
    cleanOnBoot = true;
  };

  # ============================================================================
  # SUPPORTED FILESYSTEMS
  # ============================================================================
  boot.supportedFilesystems = [ "btrfs" "f2fs" ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;

  boot.plymouth = {
    enable = true;
    theme = "rings";
    themePackages = with pkgs; [
      # By default we would install all themes
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "rings" ];
      })
    ];
  };
}
