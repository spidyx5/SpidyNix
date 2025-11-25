# User Settings Configuration

This guide explains how users can easily change their timezone and keyboard layout settings.

## 🎯 What Can Be Changed

- **Editors**: Choose which code editors to install (Helix, Neovim, VSCode, Zed)
- **Browsers**: Choose which web browsers to install (Chromium, Qutebrowser, Zen)
- **Terminals**: Choose which terminal emulators to install (Kitty)
- **Features**: Enable/disable major feature sets (virtualization, gaming)
- **Productivity**: Professional creative tools (DaVinci Resolve)
- **Virtualization Tools**: Enable/disable libvirt, Docker, Podman, Waydroid
- **Timezone**: System timezone (affects system time, logs, etc.)
- **Keyboard Layout**: XKB keyboard layout (fallback when not using keyd)
- **Niri Keyboard Layout**: Automatically synced with user preferences

## 🚀 Quick Setup (Recommended)

### Option 1: Use the Interactive Script

```bash
./change-settings.sh
```

This script will:
- Show your current timezone
- Let you choose a new timezone
- Let you set keyboard layout and variant
- Create/update `user-config.nix` automatically

### Option 2: Manual Configuration

1. **Find available timezones:**
   ```bash
   timedatectl list-timezones | grep -i america  # or your country
   ```

2. **Edit `user-config.nix`:**
   ```nix
   {
     myConfig.systemPrefs = {
       timezone = "America/New_York";  # Your timezone
       keyboard = {
         layout = "us";        # Keyboard layout
         variant = "";         # Layout variant (optional)
       };
     };
   }
   ```

3. **Apply changes:**
   ```bash
   sudo nixos-rebuild switch --flake .#Spidy
   ```

## 📋 Examples

### Full Configuration (Recommended)
```nix
{
  myConfig = {
    # Choose which editors to install
    editors = {
      helix = true;     # Fast modal editor
      neovim = false;   # Vim-based editor
      vscode = false;   # Visual Studio Code
      zed = false;      # Zed editor
    };

    # Choose which browsers to install
    browsers = {
      chromium = false; # Chromium browser
      qutebrowser = false; # Keyboard-driven browser
      zen = false;      # Zen browser
    };

    # Choose terminals
    terminals = {
      kitty = true;     # GPU-accelerated terminal
    };

    # Enable/disable major features
    virtualization = true;   # VM and container tools
    gaming = true;           # Gaming-related software

    # Professional creative tools
    productivity = {
      davinciResolve = false;     # Video editing
      davinciResolveStudio = false; # Full studio version
    };

    # Choose which virtualization tools to enable
    virtualizationTools = {
      libvirt = true;    # Enable VMs
      docker = false;    # Disable Docker (conflicts with podman)
      podman = true;     # Enable Podman containers
      waydroid = false;  # Disable Android emulation
    };

    # System preferences
    systemPrefs = {
      timezone = "America/New_York";
      keyboard = {
        layout = "us";
        variant = "colemak_dh_ortho";
      };
    };
  };
}
```

### Minimal Configuration (Just System Settings)
```nix
{
  myConfig.systemPrefs = {
    timezone = "America/New_York";
    keyboard = {
      layout = "us";
      variant = "";
    };
  };
}
```

## ✏️ Editor Options

Choose which code editors to install:

```nix
editors = {
  helix = true;     # Fast modal editor (recommended default)
  neovim = false;   # Vim-based editor with extensive plugins
  vscode = false;   # Visual Studio Code with extensions
  zed = false;      # Zed editor (fast, collaborative)
};
```

**Notes:**
- Helix is lightweight and fast with good Nix support
- Neovim offers maximum customization and plugins
- VSCode provides familiar GUI with rich extensions
- Zed is modern and fast with built-in collaboration

## 🌐 Browser Options

Choose which web browsers to install:

```nix
browsers = {
  chromium = false; # Open-source base for Chrome
  qutebrowser = false; # Keyboard-driven, vim-like browser
  zen = false;      # Firefox-based with privacy focus
};
```

**Notes:**
- Chromium is fast and widely compatible
- Qutebrowser is fully keyboard-driven
- Zen offers Firefox with enhanced privacy features

## 🐳 Virtualization Options

Choose which virtualization tools to enable:

```nix
virtualizationTools = {
  libvirt = true;    # VMs with QEMU/KVM (virt-manager)
  docker = false;    # Docker containers (don't enable with podman)
  podman = true;     # Podman containers (recommended alternative)
  waydroid = false;  # Android emulation
};
```

**Notes:**
- Docker and Podman conflict - enable only one
- libvirt enables full VM support with virt-manager
- waydroid allows running Android apps on Linux

### United Kingdom
```nix
{
  myConfig.systemPrefs = {
    timezone = "Europe/London";
    keyboard = {
      layout = "gb";
      variant = "";
    };
  };
}
```

### Germany
```nix
{
  myConfig.systemPrefs = {
    timezone = "Europe/Berlin";
    keyboard = {
      layout = "de";
      variant = "";
    };
  };
}
```

### France
```nix
{
  myConfig.systemPrefs = {
    timezone = "Europe/Paris";
    keyboard = {
      layout = "fr";
      variant = "";
    };
  };
}
```

## 🔧 Advanced Configuration

### Using Keyboard Variants

Some layouts have variants like Colemak, Dvorak, etc.:

```nix
keyboard = {
  layout = "us";
  variant = "colemak";  # or "dvorak", "qwerty"
};
```

### Custom Timezone

Find your exact timezone:
```bash
timedatectl list-timezones | grep -i tokyo
# Output: Asia/Tokyo
```

## ⚠️ Important Notes

- **Keyd Settings Preserved**: Your Colemak-DH keyd configuration in `Systems/user.nix` remains unchanged
- **Niri Sync**: Niri keyboard layout automatically uses your user preferences
- **System vs User**: These are system-level settings that affect all users
- **Rebuild Required**: Changes require `sudo nixos-rebuild switch` to take effect

## 🔍 Troubleshooting

### Timezone Not Applied
```bash
timedatectl  # Check current timezone
```

### Keyboard Layout Issues
- Keyd (system-level remapping) takes precedence
- XKB settings are fallback for applications not using keyd
- Niri uses the user-configured layout

### Revert to Defaults
Delete or comment out settings in `user-config.nix` and rebuild.

## Support

If you encounter issues:
1. Check `user-config.nix` syntax
2. Verify timezone name with `timedatectl list-timezones`
3. Test keyboard layout with `setxkbmap -layout <layout>`
4. Rebuild and check system logs: `journalctl -u nixos-rebuild`
