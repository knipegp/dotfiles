#!/usr/bin/env bash
# From https://github.com/qoheniac/config/blob/main/waybar/scripts/poweroff.sh
case $(wofi -d \
    -D dynamic_lines=true << EOF | sed 's/^ *//'
    Shutdown
    reboot
    Log off
    sleep
    lock
    cancel
EOF
) in
    "Shutdown")
        systemctl poweroff
        ;;
    "reboot")
        systemctl reboot
        ;;
    "sleep")
        ~/.config/waybar/scripts/hyprlock.sh &
        sleep 1
        systemctl suspend
        ;;
    "lock")
        ~/.config/waybar/scripts/hyprlock.sh
        ;;
    "Log off")
        hyprctl dispatch exit
        ;;
esac
