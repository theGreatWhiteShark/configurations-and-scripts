#!/bin/bash

## Turn off the blank screen every 10 minutes
# Don't activate the screensaver
xset s off
# Disable the DPMS (display power managment signaling) features
xset -dpms
# Don't blank the video device
xset s noblank

# Startup i3
exec i3

# Load my X11 configuration
[ -f ~/.xprofile ] && source ~/.xprofile

