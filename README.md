# SpidyNix

A  NixOS configuration with niri.

## Installation

### Clone the Repository

```bash
# For existing NixOS systems
sudo git clone https://github.com/spidyx5x/SpidyNix /etc/nixos

# For live ISO installations
sudo git clone https://github.com/spidyx5x/SpidyNix /mnt/etc/nixos
```
# Make sure you choose your driver,local,keyboard from the user-config or script

### Generate Hardware Configuration

Before applying the configuration, generate a hardware configuration for your system:

```bash
# Generate hardware configuration
sudo nixos-generate-config --show-hardware-config > /etc/nixos/SpidyNix/Nix/Spidy/hardware-configuration.nix
```

### Apply Configuration

#### For Existing NixOS Systems

```bash
sudo nixos-rebuild switch --flake /etc/nixos/SpidyNix#Spidy


```

#### For Fresh Installations (Live ISO)

After setting up partitions and mounting them to `/mnt`:

```bash
sudo nixos-install --root /mnt --flake /mnt/etc/nixos/SpidyNix#Spidy
```

### Rebuild & Switch

After initial installation, you can rebuild and switch to a new configuration:

```bash
# Using home-manager
home-manager switch

# Or using nh (faster alternative)
nh os switch /etc/nixos/SpidyNix --hostname Spidy

### ⚠️ CPU Compatibility Note

The configuration might require x86_64-v3 CPU support. If your CPU is different, comment out lines 82-91 in `/etc/nixos/SpidyNix/Systems/nixos.nix`.

### Using the Installation Script

⚠️ **Note**: The installation script (`spidynix`) is experimental and may not work in all environments.

```bash
# Make the script executable
chmod +x spidynix

# Run the interactive installer
sudo ./spidynix
```

### Changing Configuration Settings

```bash
# Make the settings script executable
chmod +x change-settings

# Run the settings configurator
sudo ./change-settings
```

### Rebuild Your System

```bash
# Apply configuration changes
sudo nixos-rebuild switch
```
- **Username**: spidy
- **Password**: spidy

## Secrets Management (SOPS)

This configuration uses **SOPS (Secrets OPerationS)** for managing encrypted secrets such as passwords, API keys, and other sensitive data.

### SOPS Configuration Files

- **`.sops.yaml`** - SOPS configuration defining encryption rules and keys
- **`secrets.yaml`** - Encrypted secrets file (contains actual secret values)
- **`password`** - Age/SOPS private key for decryption

### Managing Secrets

**To edit encrypted secrets:**
```bash
# Decrypt and edit secrets
sops secrets.yaml

# Or use your preferred editor
SOPS_AGE_KEY_FILE=Nix/Secrets/password sops --input-type yaml --output-type yaml secrets.yaml
```

**To encrypt new secrets:**
```bash
# Add new secret to secrets.yaml
sops --encrypt --in-place secrets.yaml
```

### SOPS Setup

The configuration is set up to automatically decrypt secrets during system builds. The Age key file should be kept secure.


## Directory Structure

```
SpidyNix/
├── flake.nix
├── flake.lock
├── SpidyNix.sh
├── change-settings.sh
├── user-config.nix
├── Homes/
│   ├── home.nix
│   ├── apps/
│   │   ├── chromium-flag.nix
│   │   ├── edge.nix
│   │   ├── fuzzel.nix
│   │   ├── obs.nix
│   │   ├── qutebrowser.nix
│   │   ├── twitch.nix
│   │   ├── yazi.nix
│   │   └── zen-browser.nix
│   ├── configs/
│   │   ├── mako.nix
│   │   ├── niri.nix
│   │   ├── rnnoise.nix
│   │   ├── theme.nix
│   │   ├── vm.nix
│   │   └── xdg.nix
│   ├── devs/
│   │   ├── git.nix
│   │   ├── helix.nix
│   │   ├── neovim.nix
│   │   ├── nushell.nix
│   │   ├── terminal.nix
│   │   ├── vscode.nix
│   │   └── zed.nix
│   └── packages/
│       ├── desktop.nix
│       ├── development.nix
│       ├── gaming.nix
│       └── productive.nix
├── Nix/
│   ├── Persist/
│   │   ├── niri.md
│   │   └── nix.md
│   ├── Secrets/
│   │   ├── .sops.yaml
│   │   ├── password
│   │   └── secrets.yaml
│   ├── Spidy/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── spidy-profile.nix
│   └── Spooda/
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── spooda-profile.nix
├── Softwares/
│   ├── basic.nix
│   ├── font.nix
│   ├── program.nix
│   ├── software.nix
│   ├── virtualization.nix
│   └── wayland.nix
└── Systems/
    ├── blacklist.nix
    ├── boot.nix
    ├── hardware.nix
    ├── login.nix
    ├── network.nix
    ├── nixos.nix
    ├── power.nix
    ├── security.nix
    ├── service.nix
    ├── sound.nix
    ├── system.nix
    └── user.nix
```
## TODO
Many things

## Credits

linuxmobile/kaku
```
theblackdon/black-don-os 
```