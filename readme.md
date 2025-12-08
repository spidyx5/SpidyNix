# SpidyNix

A modular NixOS configuration featuring.

## Quick Start

### Clone Repository

```bash
# For existing system
sudo git clone https://github.com/spidyx5/SpidyNix.git /etc/nixos/SpidyNix

# For live ISO installation
sudo git clone https://github.com/spidyx5/SpidyNix.git /mnt/etc/nixos/SpidyNix
```


### Build & Switch

```bash
# Using nh (recommended)
cd /etc/nixos/SpidyNix
nh os switch --hostname Spidy

# Or using nixos-rebuild
sudo nixos-rebuild switch --flake /etc/nixos/SpidyNix#Spidy
```

### Live ISO Installation

```bash
sudo nixos-install --root /mnt --flake /mnt/etc/nixos/SpidyNix#Spidy
```

## Spider Profile


### Step 1: Clone Repository

```bash
sudo git clone https://github.com/spidyx5/SpidyNix.git /etc/nixos/SpidyNix
cd /etc/nixos/SpidyNix
```

### Step 2: Generate Your Hardware Configuration

**CRITICAL:** This creates hardware detection for YOUR specific system:

```bash
# Generate hardware config (runs nixos-generate-config automatically)
sudo nixos-generate-config
```

### Step 3: Rebuild System

```bash
# Using nh (recommended)
sudo nh os switch /etc/nixos/SpidyNix --hostname spider

# Or using nixos-rebuild
sudo nixos-rebuild switch --flake /etc/nixos/SpidyNix#spider
```

### Step 4: (Optional) Customize

Edit configuration as needed:
```bash
sudo nano /etc/nixos/SpidyNix/Spidy/spider-config.nix
```

### Live ISO Installation (Spider Profile)

```bash
# Clone to ISO root
sudo git clone https://github.com/spidyx5/SpidyNix.git /mnt/etc/nixos/SpidyNix

# Generate hardware config for target system
nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix

# Install with spider profile
sudo nixos-install --root /mnt --flake /mnt/etc/nixos/SpidyNix#spider
```

## Default Credentials

| Setting | Value |
|---------|-------|
| **Username** | `spidy` |
| **Password** | `spidy` |
| **Hostname** | `Spidy` or `spider` |

⚠️ **Change password after first login:**
```bash
passwd
```

## Troubleshooting Hardware Generation

### Hardware Config Not Found
```bash
# Manually generate
sudo nixos-generate-config --root /

# Check it was created
cat /etc/nixos/hardware-configuration.nix
```

### Different Devices/Filesystems
The auto-generated config should handle most cases. If you have:
- Custom LVM setup
- Multiple drives
- Special RAID configuration

Edit `/etc/nixos/hardware-configuration.nix` manually after generation.

### Rebuild After Generation
```bash
# If hardware config changes
sudo nixos-rebuild switch --flake /etc/nixos/SpidyNix#spider
```

## Directory Structure

```
/etc/nixos/SpidyNix
├── flake.nix
├── README.md
└── Spidy
    ├── configuration.nix
    └── hardware-configuration.nix
```

