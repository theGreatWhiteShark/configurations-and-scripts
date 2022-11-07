#!/bin/bash

# Stop potential none save for work stuff
killall firefox-esr
killall thunderbird

# Start work profile of
xrdb -merge -I$HOME ~/git/configurations-and-scripts/linux/.Xresources-work
i3-msg reload

firefox -P work &
disown

# Start VPN
sudo openvpn --config /home/phil/software/vpn/dhd_vpn_config.ovpn
