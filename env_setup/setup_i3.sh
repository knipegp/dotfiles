#!/bin/bash

# Check if running as root
# https://stackoverflow.com/questions/18215973/how-to-check-if-running-as-root-in-a-bash-script

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install necessary packages
apt update
apt install xbacklight alsa-utils pulseaudio
