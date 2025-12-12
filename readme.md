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
or
NH_FLAKE=/etc/nixos/SpidyNix nh os switch . --hostname Spidy

# Or using nixos-rebuild
sudo nixos-rebuild switch --flake /etc/nixos/SpidyNix#Spidy
```

### Live ISO Installation

```bash
sudo nixos-install --root /mnt --flake /mnt/etc/nixos/SpidyNix#Spidy
```

# Generate hardware config for target system
nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix

```

## Default Credentials

| Setting | Value |
|---------|-------|
| **Username** | `spidy` |
| **Password** | `spidy` |
| **Hostname** | `Spidy` |

 **Change password after first login:**
```bash
passwd
```

## Directory Structure

```
/etc/nixos/SpidyNix/
├── flake.lock
├── flake.nix
├── readme.md
├── Homes/
│   ├── home.nix
│   ├── app/
│   │   ├── git.nix
│   │   ├── helix.nix
│   │   ├── neovim.nix
│   │   ├── nushell.nix
│   │   ├── starship.nix
│   │   ├── vscode.nix
│   │   ├── xdg.nix
│   │   └── zed.nix
│   ├── config/
│   │   ├── chromium.nix
│   │   ├── edge.nix
│   │   ├── obs.nix
│   │   ├── qutebrowser.nix
│   │   ├── rnnoise.nix
│   │   ├── twitch.nix
│   │   ├── vm.nix
│   │   └── zen.nix
│   └── dotfile/
│       ├── dms.nix
│       ├── fuzzel.nix
│       ├── mako.nix
│       ├── niri.nix
│       ├── noctalia.nix
│       ├── theme.nix
│       ├── wayland.nix
│       └── yazi.nix
├── Spidy/
│   ├── niri.md
│   ├── secrets/
|   |── wallpaper/
│   └── spidy-config.nix
└── Systems/
    ├── basic.nix
    ├── boot.nix
    ├── hardware.nix
    ├── nixos.nix
    ├── overlay.nix
    ├── program.nix
    ├── service.nix
    └── virtualization.nix
```

