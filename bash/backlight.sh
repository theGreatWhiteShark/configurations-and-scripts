#!/bin/bash

# Since 'xbacklight' does not work on temeluchus, this script will
# increase (or decrease) the backlight by a certain percentage.

# --------------------------------------------------------------------
# Assure a number between 0 and 100 is provided as input.
integer_regex='^[0-9]+$'
if ! [[ $1 =~ $integer_regex ]]; then
	echo "ERROR: Please provide an integer as input argument!" >&2
	# exit 1
fi

if [ $1 -lt 0 ] || [ $1 -gt 100 ]; then
	echo "ERROR: Input out of bound. Please provide an integer between 0 and 100!" >&2
	# exit 1
fi

# --------------------------------------------------------------------
# Get maximal and current backlight value of the system
brightness_max=$(cat /sys/class/backlight/intel_backlight/max_brightness)
brightness_old=$(cat /sys/class/backlight/intel_backlight/brightness)

# --------------------------------------------------------------------
# Calculate the change in value from the supplied maximum.
# Since BASH is not supporting floating point arithmetic, the value get's rounded
value_change=$((brightness_max*$1/100))

# --------------------------------------------------------------------
# Calculate the new brigthness and sanity checking for the value
brightness_new=$((brightness_old+value_change))
if [ $brightness_new -gt $brightness_max ];then
    brightness_new=$brightness_max
fi
if [ $brightness_new -lt 0 ];then
    brightness_new=0
fi

# --------------------------------------------------------------------
# Check whether the brightness file can be written too. It either has
# to be owned by the current user of must be writable for 'others'.

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

if [ "$(stat -c '%U' /sys/class/backlight/intel_backlight/brightness)" == "$USER" ] || $writable; then

	# Writting the new value to 
	echo $brightness_new > /sys/class/backlight/intel_backlight/brightness

else

	echo "ERROR: Unable to update /sys/class/backlight/intel_backlight/brightness. Insufficient permissions: $permission_value!" >&2
	# exit 1

fi

