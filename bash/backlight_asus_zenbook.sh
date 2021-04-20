#!/bin/bash

function set_asus_zenbook_backlight {
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

	CURRENT_BACKLIGHT=$(cat /sys/class/backlight/intel_backlight/brightness)
	MAX_BACKLIGHT=$(cat /sys/class/backlight/intel_backlight/max_brightness)

	NEW_VALUE=$(echo "$CURRENT_BACKLIGHT + ($1 * $MAX_BACKLIGHT / 100)" | bc)
	
	echo $NEW_VALUE | sudo tee /sys/class/backlight/intel_backlight/brightness
}

# --------------------------------------------------------------------
# Adjust the brightness of the Aspire S3

set_asus_zenbook_backlight $1

