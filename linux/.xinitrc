#!/bin/bash

## Turn off the blank screen every 10 minutes
# Don't activate the screensaver
xset s off
# Disable the DPMS (display power managment signaling) features
xset -dpms
# Don't blank the video device
xset s noblank

# Load my X11 configuration
if [ -f ~/.xprofile ]; then
	source ~/.xprofile
fi

if [ -f ~/.Xresources ]; then
	xrdb -merge -I$HOME ~/.Xresources
fi

# Startup i3
exec i3


