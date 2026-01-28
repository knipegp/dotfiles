#!/usr/bin/env bash
# Disable laptop screen when lid is closed

# Get laptop screen name (eDP-*, LVDS-*, DSI-*)
laptop_screen=$(swaymsg -t get_outputs -r | jq -r '.[] | select(.name | test("^(eDP|LVDS|DSI)")) | .name' | head -n1)

if [ -z "$laptop_screen" ]; then
	echo "Error: Could not detect laptop screen" >&2
	exit 1
fi

# Disable laptop screen
swaymsg output "$laptop_screen" disable
