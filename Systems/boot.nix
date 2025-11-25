# /etc/nixos/SpidyNix/Systems/boot.nix
{ config, pkgs, lib, ... }:
{
  # ============================================================================
  # BOOTLOADER - LIMINE
  # ============================================================================
  # Limine is a modern, fast bootloader with EFI support
  # ============================================================================
  boot.loader = {
    limine = {
      enable = true;                  # Enable Limine bootloader
      efiSupport = true;             # Enable EFI support
    };

    # EFI variables support
    efi = {
      canTouchEfiVariables = true;   # Allow modifying EFI variables
      efiSysMountPoint = "/boot";    # Mount EFI system partition at /boot
    };
  };

  # ============================================================================
  # KERNEL CONFIGURATION
  # ============================================================================
  # CachyOS kernel provides optimizations for performance and responsiveness
  # ============================================================================
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos-lto;  # Use CachyOS kernel

  # ============================================================================
  # KERNEL PARAMETERS
  # ============================================================================
  # Boot parameters for security, performance, and hardware support
  # ============================================================================
  boot.kernelParams = [
    # --- Performance Optimizations ---
    "nvme_core.default_ps_max_latency_us=0"  # NVMe max performance
    "zswap.enabled=1"                        # Enable zswap compression
    "mitigations=off"                        # Disable CPU mitigations (performance over security)
    "rootflags=noatime"                      # Disable access time updates
    "nowatchdog"                             # Disable watchdog entirely
    "kernel.split_lock_mitigate=0"            # Crucial for gaming (prevents fps drops)

    # --- Security Hardening ---
    "init_on_alloc=1"                        # Initialize allocated memory
    "init_on_free=1"                         # Initialize freed memory
    "randomize_kstack_offset=on"             # Randomize kernel stack offset
    "vsyscall=none"                          # Disable legacy vsyscall
    "slab_nomerge"                           # Prevent SLAB merging
    "page_alloc.shuffle=1"                   # Randomize page allocator

    # --- LSM Stack ---
    "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"  # Loadable Security Modules

    # --- Boot Aesthetics ---
    "quiet"                                  # Reduce boot messages
    "systemd.show_status=auto"               # Show systemd status conditionally
    "rd.udev.log_level=3"                     # Reduce udev log verbosity
    "plymouth.use-simpledrm"                 # Use simple DRM for Plymouth
     #"acpi_sleep_default=deep"
     #"acpi_sleep=nonvs"
     #"mem_sleep_default=deep"
     # resume=/dev/mapper/mock-fan
  ] ++ lib.optionals config.hardwareType.intel [
    "intel_idle.max_cstate=4"                # Intel CPU C-state limit
    "intel_pstate=passive"                   # Intel P-state passive mode
    "intel_iommu=on"                         # Enable Intel IOMMU
    "kvm-intel.nested=0"                     # Disable nested virtualization
  ] ++ lib.optionals config.hardwareType.amd [
    "amd_pstate=passive"                     # AMD P-state passive mode
    "amd_iommu=on"                           # Enable AMD IOMMU
    "kvm-amd.nested=0"                       # Disable nested virtualization
  ] ++ lib.optionals config.hardwareType.nvidia [
    # NVIDIA specific params if needed
  ] ++ lib.optionals config.hardwareType.vm [
    # VM specific params
  ] ++ [
    "iommu=pt"                               # Enable IOMMU passthrough
  ];

  boot.consoleLogLevel = 0;                  # Reduce console log level
  boot.initrd.verbose = false;                # Disable verbose initrd

  # ============================================================================
  # KERNEL MODULES
  # ============================================================================
  # Modules to load at boot and in initrd
  # ============================================================================
  boot.kernelModules = [
    "kvm"
    "v4l2loopback"   # Virtual video device (for OBS)
    "i2c-dev"        # I2C device support
    "efivarfs"       # EFI variable filesystem
    "uinput"         # User input device
    "tcp_bbr"        # BBR congestion control
    "uinput"           # User input device emulation
    "hid_nintendo"     # Nintendo Switch controllers
    "xpad"             # Xbox controllers
    # Networking
    "tun"           # TUN/TAP devices for VM networking
    "vhost_net"     # Vhost-net for better network performance
  ] ++ lib.optionals config.hardwareType.intel [
    "kvm-intel"      # Intel KVM virtualization
    "i915"           # Intel graphics
  ] ++ lib.optionals config.hardwareType.amd [
    "kvm-amd"        # AMD KVM virtualization
    "amdgpu"         # AMD graphics
  ] ++ lib.optionals config.hardwareType.nvidia [
    # NVIDIA modules if needed
  ] ++ lib.optionals config.hardwareType.vm [
    "virtio"         # VirtIO for VMs
    "virtio_pci"
    "virtio_net"
    "virtio_blk"
  ];

  # ============================================================================
  # INITRD MODULES
  # ============================================================================
  # Initrd kernel modules (loaded during early boot)
  # ============================================================================
  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"     # USB 3.0 controller
      "ahci"         # SATA controller
      "nvme"         # NVMe drives
      "usbhid"       # USB HID devices
      "usb_storage"  # USB storage
      "sd_mod"       # SCSI disk support
    ];

    kernelModules = [
      "btrfs"        # Btrfs filesystem
      "dm-snapshot"  # Device mapper snapshots
      "dm-crypt"     # Device mapper encryption
      "dm-mod"       # Device mapper core
      "dm-thin-pool" # Thin pool logical volume
      "dm-mirror"    # General LVM support
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"
      "kvm"
    ] ++ lib.optionals config.hardwareType.intel [
      "i915"         # Intel graphics (early load)
    ] ++ lib.optionals config.hardwareType.amd [
      "amdgpu"       # AMD graphics (early load)
    ] ++ lib.optionals config.hardwareType.nvidia [
      # NVIDIA early load if needed
    ] ++ lib.optionals config.hardwareType.vm [
      "virtio"       # VirtIO for VMs
      "virtio_pci"
      "virtio_net"
      "virtio_blk"
    ];
  };

  # ============================================================================
  # EXTRA MODULE PACKAGES
  # ============================================================================
  # Extra kernel modules (packages)
  # ============================================================================
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback  # v4l2loopback module
  ];

  # ============================================================================
  # KERNEL MODULE OPTIONS
  # ============================================================================
  # Module-specific configuration (modprobe options)
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
    options bluetooth disable_ertm=1
  '';

  # ============================================================================
  # SYSCTL - KERNEL RUNTIME PARAMETERS
  # ============================================================================
  # System control parameters for performance and security tuning
  # ============================================================================
  boot.kernel.sysctl = {
    # --- Memory Management ---
    "vm.swappiness" = lib.mkDefault 100;       # Higher swap usage preference
    "vm.vfs_cache_pressure" = 50;            # Reduce cache pressure
    "vm.dirty_ratio" = 10;                   # Max dirty memory before writeback
    "vm.dirty_background_ratio" = 5;         # Background writeback threshold
    "vm.watermark_scale_factor" = 200;       # Memory reclaim aggressiveness
    "vm.overcommit_memory" = 1;              # Always overcommit memory
    "vm.max_map_count" = 2147483642;         # Max memory map areas (for games)
    "vm.mmap_rnd_bits" = 32;                 # ASLR entropy for mmap
    "vm.mmap_rnd_compat_bits" = 16;          # ASLR entropy for compat mmap
    "vm.unprivileged_userfaultfd" = 0;       # Disable unprivileged userfaultfd



    # --- Kernel Security ---
    "kernel.sysrq" = 0;                      # Disable magic SysRq key
    "kernel.kptr_restrict" = 2;              # Hide kernel pointers
    "kernel.dmesg_restrict" = 1;             # Restrict dmesg access
    "kernel.nmi_watchdog" = 0;               # Disable NMI watchdog
    "kernel.core_uses_pid" = 1;              # Append PID to core dumps
    "kernel.randomize_va_space" = 2;         # Full ASLR

    # --- Filesystem Security ---
    "fs.protected_fifos" = 2;                # Protect FIFOs
    "fs.protected_regular" = 2;              # Protect regular files
    "fs.suid_dumpable" = 0;                  # No SUID core dumps

    # --- TTY Security ---
    "dev.tty.ldisc_autoload" = 0;      # Disable TTY line discipline autoload
  };

  # ============================================================================
  # APPIMAGE SUPPORT
  # ============================================================================
  # AppImage support
  # ============================================================================
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;         # Don't wrap in shell
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";  # AppImage interpreter
    recognitionType = "magic";               # Use magic number recognition
    offset = 0;                              # Offset for magic number
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';  # Mask for magic number
    magicOrExtension = ''\x7fELF....AI\x02'';  # Magic number for AppImage
  };

  # ============================================================================
  # SYSTEMD COREDUMP CONFIGURATION
  # ============================================================================
  # Disable core dumps for security
  # ============================================================================
  systemd.coredump.extraConfig = ''
    Storage=none
    ProcessSizeMax=0
  '';

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 spidy kvm -"
  ];

  # ============================================================================
  # PLYMOUTH - BOOT SPLASH
  # ============================================================================
  # Beautiful boot splash screen
  # ============================================================================
  boot.plymouth.enable = true;               # Enable Plymouth boot splash

  # ============================================================================
  # TEMPORARY FILES
  # ============================================================================
  # Temporary filesystem and cleanup configuration
  # ============================================================================
  boot.tmp = {
    useTmpfs = true;        # Use tmpfs for /tmp (faster, in RAM)
    cleanOnBoot = true;     # Clean /tmp on boot
  };

  # ============================================================================
  # SUPPORTED FILESYSTEMS
  # ============================================================================
  # Enable support for various filesystems
  # ============================================================================
  boot.supportedFilesystems = [ "btrfs"  "f2fs" ];  # Supported filesystems
}
# ============================================================================
# BOOT CONFIGURATION
# ============================================================================
# This file configures the boot process including:
#   - Bootloader (Limine with EFI support)
#   - Kernel (CachyOS for performance)
#   - Kernel parameters (security and performance tuning)
#   - Kernel modules (hardware support)
#   - System control (sysctl) tuning
#   - Boot aesthetics (Plymouth)
# ============================================================================
# NOTES:
# - Limine is a modern, fast bootloader with EFI support
# - CachyOS kernel is optimized for performance
# - Kernel parameters are tuned for security and performance
# - Kernel modules are configured for hardware support
# - Sysctl parameters are set for system tuning
# - Plymouth provides a beautiful boot splash
# - For troubleshooting:
#   - Check boot logs: journalctl -b
#   - Verify kernel parameters: cat /proc/cmdline
#   - Check loaded modules: lsmod
#   - Verify sysctl settings: sysctl -a
# - To customize:
#   - Adjust kernel parameters as needed
#   - Add/remove kernel modules
#   - Modify sysctl settings
#   - Change bootloader settings
# ============================================================================
