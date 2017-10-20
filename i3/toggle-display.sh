#!/bin/bash

# This short script detects whether or not a new display was added
# before restarting the i3 window manager. If so, it will run some
# `xrandr' commands to enable it.

# Test whether there is a display which is not running in its
# prefered mode.
if [ $( xrandr --current | grep -E "[[:digit:]]* \+" | wc -c) > 0 ];then
    # Number of line the detection above occured in.
    mode_line=$(xrandr --current | awk '/[:digit:]* \+/ { print NR }')

    # Number of line the discription of the display is residing in.
    # It checks for all line numbers of the device descriptions if they
    # are smaller than the mode_line (since the different modes are
    # printed below the description) and returns the last matching
    # element.
    display_line=$(xrandr --current | awk '/connected/{print NR}' | awk -v mode_line=$mode_line '{if (mode_line > $0) display_line=$1} END {print display_line}')

    # Extract the name of the display
    display_name=$(xrandr --current | awk -v display_line=$display_line '{if (NR==display_line) print $1}')

    # Extract the display's prefered mode
    display_mode=$(xrandr --current | awk -v mode_line=$mode_line '{if (NR==mode_line) print $1}')

    # Activate the display in its prefered mode
    xrandr --output $display_name --mode $display_mode

    # Source my custom X11 configuration.
    source ~/.xprofile
fi

# Check whether an additional display was removed.
# When removing additional displays in i3 the xrandr does not seem to
# turn them off. Instead one manually has to do it manually.
# So in here it will be checked whether there is a disconnected displays
# with still a mode attached to it.
if [ $(xrandr --current | grep -E "disconnected [[:digit:]]+" | wc -c) > 0 ];then.
   display_names_off=$(xrandr --current | grep -E "disconnected [[:digit:]]+" | awk '{print $1}')

   # Turn off all extracted devices
   for dd in $display_names_off;do
       xrandr --output $dd --off
   done
fi

# Just to be save also run the `xrandr' command with the output
# option on all connected displays.
display_names_auto=$(xrandr --current | grep -E "connected [[:digit:]]+" | awk '{print $1}')
for dd in $display_names_auto;do
    xrandr --output $dd --auto
done
