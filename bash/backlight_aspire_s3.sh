#!/bin/bash

function set_aspire_s3_backlight {
	# Since 'xbacklight' does not work on an Aspire S3, this script
	# will increase (or decrease) the backlight by a certain
	# percentage.
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
	# Get maximal and current backlight value of the system
	brightness_max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
	brightness_old=$(cat /sys/class/backlight/intel_backlight/brightness)

	# ----------------------------------------------------------------
	# Calculate the change in value from the supplied maximum.  Since
	# BASH is not supporting floating point arithmetic, the value
	# get's rounded
	value_change=$(($brightness_max*$1/100))

	# ----------------------------------------------------------------
	# Calculate the new brigthness and sanity checking for the value
	brightness_new=$(($brightness_old+$value_change))
	if [ $brightness_new -gt $brightness_max ];then
		brightness_new=$brightness_max
	fi
	if [ $brightness_new -lt 0 ];then
		brightness_new=0
	fi


	# ----------------------------------------------------------------
	# Check whether the brightness file can be written too. It either
	# has to be owned by the current user of must be writable for
	# 'others'.

	# Check whether the brightness file is writable.
	permission_value=`stat -c '%a' /sys/class/backlight/intel_backlight/brightness | sed -e 's/\(^.*\)\(.$\)/\2/'`

	case "$permission_value" in
		2)
			writable=true
			;;
		6)
			writable=true
			;;
		7)
			writable=true
			;;
		*)
			writable=false
			;;
	esac

	# ----------------------------------------------------------------
	# Write the new brightness values.
	
	if [ "$(stat -c '%U' /sys/class/backlight/intel_backlight/brightness)" == "$USER" ] || $writable; then

		# Writting the new value to 
		echo $brightness_new > /sys/class/backlight/intel_backlight/brightness

	else

		echo "ERROR: Unable to update /sys/class/backlight/intel_backlight/brightness. Insufficient permissions: $permission_value!" >&2
		exit 1

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
