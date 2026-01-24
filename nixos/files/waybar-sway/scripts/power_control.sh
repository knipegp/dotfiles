#!/usr/bin/env bash
# From https://github.com/qoheniac/config/blob/main/waybar/scripts/poweroff.sh
case $(
	printf "Shutdown\nreboot\nLog off\nsleep\nlock\ncancel" | bemenu -l 6 -p "Power:"
) in
"Shutdown")
	systemctl poweroff
	;;
"reboot")
	systemctl reboot
	;;
"sleep")
	~/.config/waybar/scripts/swaylock-blur.sh &
	sleep 1
	systemctl suspend
	;;
"lock")
	~/.config/waybar/scripts/swaylock-blur.sh
	;;
"Log off")
	swaymsg exit
	;;
esac
