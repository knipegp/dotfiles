#!/usr/bin/env bash
# Check lid state on sway config reload and adjust laptop screen accordingly

# Get laptop screen name (eDP-*, LVDS-*, DSI-*)
laptop_screen=$(swaymsg -t get_outputs -r | jq -r '.[] | select(.name | test("^(eDP|LVDS|DSI)")) | .name' | head -n1)

if [ -z "$laptop_screen" ]; then
	echo "Error: Could not detect laptop screen" >&2
	exit 1
fi

# Find lid state file (may be LID0, LID, etc.)
lid_state_file=$(find /proc/acpi/button/lid -name "state" 2>/dev/null | head -n1)

if [ -z "$lid_state_file" ]; then
	echo "Warning: Could not find lid state file" >&2
	exit 0
fi

# Read lid state
lid_state=$(cat "$lid_state_file")

case "$lid_state" in
*open*)
	swaymsg output "$laptop_screen" enable
	;;
*closed*)
	swaymsg output "$laptop_screen" disable
	;;
*)
	echo "Warning: Could not determine lid state: $lid_state" >&2
	;;
esac
