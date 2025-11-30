# SpidyNix

A modular NixOS configuration featuring the Niri window manager.

## Installation

### Clone the Repository

```bash
# For existing NixOS systems
sudo git clone https://github.com/spidyx5/SpidyNix.git /etc/nixos/SpidyNix

# For live ISO installations
sudo git clone https://github.com/spidyx5/SpidyNix.git /mnt/etc/nixos/SpidyNix
```

### Generate Hardware Configuration

Generate a hardware configuration for your system:

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

After partitioning and mounting to `/mnt`:

```bash
sudo nixos-install --root /mnt --flake /mnt/etc/nixos/SpidyNix#Spidy --cores 0 --max-jobs 0
```

### Post-Installation

Rebuild and switch to apply changes:

```bash
# Using nh (recommended)
nh os switch /etc/nixos/SpidyNix --hostname Spidy

# Or using nixos-rebuild
sudo nixos-rebuild switch --flake /etc/nixos/SpidyNix#Spidy
```

**Default Credentials:**
- Username: `spidy`
- Password: `spidy`

### ⚠️ CPU Compatibility Note

This configuration may require x86_64-v3 CPU support. If your CPU lacks this, comment out lines 82-91 in `Systems/nixos.nix`.

## Secrets Management (SOPS)

This configuration uses SOPS for managing encrypted secrets.

### Key Files
- `Nix/Secrets/.sops.yaml` - SOPS configuration
- `Nix/Secrets/secrets.yaml` - Encrypted secrets
- `Nix/Secrets/password` - Age private key

### Managing Secrets

Edit secrets:
```bash
sops Nix/Secrets/secrets.yaml
```

Encrypt new data:
```bash
sops --encrypt --in-place Nix/Secrets/secrets.yaml
```

Secrets are automatically decrypted during builds.

## Directory Structure

```
SpidyNix/
├── flake.nix
├── flake.lock
├── readme.md
├── Homes/
│   ├── home.nix
│   ├── apps/          # Application configurations
│   ├── configs/       # System configs (niri, mako, etc.)
│   ├── devs/          # Development tools
│   └── packages/      # Package sets
├── Nix/
│   ├── Persist/       # Persistent data docs
│   ├── Secrets/       # Encrypted secrets
│   └── Spidy/         # Host-specific configs
└── Systems/           # System-wide modules
    ├── boot.nix
    ├── hardware.nix
    ├── network.nix
    ├── nixos.nix
    ├── sound.nix
    ├── user.nix
    └── ...
```

## Credits

- [linuxmobile/kaku](https://github.com/linuxmobile/kaku) - 
- [theblackdon/black-don-os](https://gitlab.com/theblackdon/black-don-os) - 