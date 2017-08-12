#!/bin/bash

# Since 'xbacklight' does not work on temeluchus, this script will
# increase (or decrease) the backlight by a certain percentage.

# Get maximal and current backlight value of the system
brightness_max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
brightness_old=$(cat /sys/class/backlight/intel_backlight/brightness)


# Calculate the change in value from the supplied maximum.
# Since BASH is not supporting floating point arithmetic, the value get's rounded
value_change=$((brightness_max*$1/100))

# Calculate the new brigthness and sanity checking for the value
brightness_new=$((brightness_old+value_change))
if [ $brightness_new -gt $brightness_max ];then
    brightness_new=$($brightness_max)
fi
if [ $brightness_new -lt 0 ];then
    brightness_new=0
fi

# Writting the new value to 
echo $brightness_new > /sys/class/backlight/intel_backlight/brightness
