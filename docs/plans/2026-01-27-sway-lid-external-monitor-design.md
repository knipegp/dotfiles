# Sway Lid External Monitor Design

**Date:** 2026-01-27

## Requirements

When using sway:

- Lid closed + no external monitor → suspend-then-hibernate (existing behavior)
- Lid closed + external monitor present → disable laptop screen, no suspend
- Lid opened + external monitor present → re-enable laptop screen
- Lid opened + no external monitor → laptop screen already enabled
- Charging state does not affect suspend behavior

## Architecture

### Components

1. **Sway bindswitch**: Native sway lid event handling via `bindswitch --reload --locked`
2. **Helper scripts**: Auto-detect laptop screen and handle enable/disable commands
3. **Logind integration**: Use `lidSwitchDocked = "ignore"` to prevent suspend when external display connected

### How it works

**Lid close event:**

1. Sway's `bindswitch lid:on` triggers helper script
2. Script auto-detects laptop screen (eDP-*, LVDS-*, DSI-*)
3. Script disables laptop screen via `swaymsg output <name> disable`
4. Logind detects lid close event
5. Logind checks if system is "docked" (external displays present)
6. If docked → no action (lidSwitchDocked = ignore)
7. If not docked → suspend-then-hibernate

**Lid open event:**

1. Sway's `bindswitch lid:off` triggers helper script
2. Script auto-detects laptop screen
3. Script enables laptop screen via `swaymsg output <name> enable`

**Config reload handling:**

- `exec_always` runs a script that checks current lid state in `/proc/acpi/button/lid/`
- Ensures clamshell mode persists across sway reloads

## Implementation

### Files to modify

1. `/home/griff/dotfiles/nixos/files/sway/config.d/laptop.conf` - Add bindswitch configuration
2. `/home/griff/dotfiles/nixos/files/sway/scripts/` - Create three helper scripts:
   - `lid-close.sh` - Disable laptop screen
   - `lid-open.sh` - Enable laptop screen
   - `check-lid-state.sh` - Check lid state on config reload
3. `/home/griff/dotfiles/nixos/modules/system/laptop-power.nix` - Add `lidSwitchDocked = "ignore"`
4. `/home/griff/dotfiles/nixos/modules/system/sway.nix` - Add `jq` to system packages
5. `/home/griff/dotfiles/nixos/modules/user/desktop-sway.nix` - Deploy scripts via home.file

### Script logic

All scripts follow this pattern:

1. Use `swaymsg -t get_outputs -r` to get JSON output list
2. Use `jq` to find first output matching regex `eDP-.*|LVDS-.*|DSI-.*`
3. Execute appropriate `swaymsg output <name> enable|disable` command
4. Log errors to stderr if laptop screen not found

### Dependencies

- `jq` - JSON parsing for swaymsg output

## Benefits

- No custom systemd services needed
- Uses native sway functionality
- Leverages logind's built-in dock detection
- Simple, maintainable shell scripts
- Persistent across config reloads
