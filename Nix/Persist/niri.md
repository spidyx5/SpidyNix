# Niri Configuration Guide

## Overview
Niri is a scrollable-tiling Wayland compositor. This guide explains how to configure and customize Niri for your setup.

## Basic Configuration
Niri's configuration is typically located in `~/.config/niri/config.ron`. This file uses the RON format.

## Key Features
- Scrollable tiling layout
- Wayland compositor
- Customizable keybindings
- Support for multiple monitors
- Window management features

## Customization
To customize Niri, edit the configuration file:
1. Open `~/.config/niri/config.ron`
2. Modify settings as needed
3. Restart Niri to apply changes

## Troubleshooting
- Check logs: `journalctl -xe | grep niri`
- Verify configuration: `niri --check-config`
- Restart Niri: `systemctl --user restart niri`

## Resources
- [Niri GitHub](https://github.com/YOURUSERNAME/niri)
- [Niri Documentation](https://niri.example.com/docs)



# USAGE:
# - Launch: niri
# - Configuration: ~/.config/niri/config.toml
# - Logs: ~/.local/share/niri/niri.log

# KEYBINDINGS:
# - Super+Q: Quit Niri
# - Super+Shift+Q: Close focused window
# - Super+Return: Launch Kitty terminal
# - Super+Space: Launch Fuzzel application launcher
# - Super+N/E/I/O: Focus left/down/up/right
# - Super+Shift+N/E/I/O: Move column left/down/up/right
# - Super+Minus/Plus: Decrease/increase column width
# - Super+Shift+Space: Toggle window floating
# - Super+F: Toggle fullscreen for the focused window
# - Super+Shift+F: Expand column to available width
# - Super+S: Switch preset column width
# - Super+W: Toggle column tabbed display
# - Super+Comma/Period: Consume/expel window from column
# - Super+C: Center visible colu       error: syntax error, unexpected end of file, expecting ';'mns
# - Super+Tab: Switch focus between floating and tiling
# - Super+1-9: Focus workspace 1-9
# - Super+Shift+1-9: Move column to workspace 1-9
# - XF86AudioRaiseVolume: Increase volume
# - XF86AudioLowerVolume: Decrease volume
# - XF86AudioMute: Toggle mute
# - XF86AudioPlay: Play/pause
# - XF86AudioNext: Next track
# - XF86AudioPrev: Previous track
# - XF86MonBrightnessUp: Increase brightness
# - XF86MonBrightnessDown: Decrease brightness
# - Print: Take screenshot of screen
# - Super+Shift+S: Take screenshot
#
# CONFIGURATION:
# - Config file: ~/.config/niri/config.toml
# - Themes: ~/.config/niri/themes/
# - Keybindings: ~/.config/niri/keybindings.toml
#
# LEARNING:
# - :help - Built-in help
# - :tutor - Interactive tutorial
# - :checkhealth - Check configuration
# ============================================================================
