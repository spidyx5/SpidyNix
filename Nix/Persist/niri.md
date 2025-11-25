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
