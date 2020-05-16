#!/bin/bash

function set_aspire_s3_backlight {
	# This script will increase (or decrease) the backlight by a
	# certain percentage using it command `light`.
	#
	# This script assumes the an integer argument specifying the
	# percentage of change. Negative values correspond to a decrease
	# of the brightness and positive ones to an increase. -10
	# e.g. does decrease the brightness by 10%.

	# ----------------------------------------------------------------
	# Assure a number between 0 and 100 is provided as input.
	integer_regex='^[-]*[0-9]+$'
	if ! [[ $1 =~ $integer_regex ]]; then
		echo "ERROR: Please provide an integer as input argument!" >&2
		exit 1
	fi

	if [ $1 -lt -100 ] || [ $1 -gt 100 ]; then
		echo "ERROR: Input out of bound. Please provide an integer between 0 and 100!" >&2
		exit 1
	fi

	# ----------------------------------------------------------------

	if [ $1 -gt 0 ]; then
		sudo light -A $1
	else
		sudo light -U $(echo "-1 * $1" | bc)
	fi
}

# --------------------------------------------------------------------

function set_external_monitor_brightness {
	# This script assumes the an integer argument specifying the
	# percentage of change. Negative values correspond to a decrease
	# of the brightness and positive ones to an increase. -10
	# e.g. does decrease the brightness by 10%.
	#
	# The second parameter is assumed to be the name of the
	# corresponding X11 device.

	# If there is no brightness file present yet, create one.
	if [ ! -f "$HOME/.i3/brightness" ]; then
		echo "1" > $HOME/.i3/brightness
	fi
	
	# ----------------------------------------------------------------
	# Since this has to be done directly via X11 and xrandr, we have
	# to use floating numbers in here. This is just a little bit a
	# pain in the ass. Let's solve this using AWK!
	
	new_value=$(awk -v change="$1" '{change_relative=change/100; brightness_new=$1 + change_relative; if(brightness_new>1)print 1; else if(brightness_new < 0) print 0; else print brightness_new}' $HOME/.i3/brightness)
	
	# ----------------------------------------------------------------
	# Store the new value on disk

	echo "$new_value" > $HOME/.i3/brightness
	
	# ----------------------------------------------------------------
	# Set the brightness to the new value

	xrandr --output $2 --brightness $new_value
	
}

# --------------------------------------------------------------------
# Adjust the brightness of the Aspire S3

set_aspire_s3_backlight $1

# --------------------------------------------------------------------
# Adjusting the brightness of an external monitor. This can not be
# done via a state file but only via X11 itself (at least to my
# knowledge).

# Corresponding device name.
device_name=$(xrandr --current | sed -e 's/disconnected//g' |
				  awk '/connected/ {if ($1 != "LVDS-1") print $1}')

# Check whether there is an external monitor connected.
if [ $(echo $device_name | wc -m) -gt 1 ]; then
	# There is a monitor present.

	set_external_monitor_brightness $1 $device_name

fi
