#!/bin/bash

killall firefox-esr
sudo killall openvpn

# Start work profile of
xrdb -merge -I$HOME ~/git/configurations-and-scripts/linux/.Xresources
i3-msg reload

firefox -P default-esr &
thunderbird &
disown
