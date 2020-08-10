#!/bin/bash

# The input will be provided as a number between -100 and 100. If 0 is
# provided, the muting will be toggled.

# Either uses amixer if the JACK server is not running or uses pactl otherwise.
HAVE_JACK=$(pactl list short sources | grep jack_out)

if [ "$(echo $HAVE_JACK | wc -w)" -gt "0" ];then
	if [ "$1" -lt "0" ];then
		pactl set-sink-volume jack_out $1%
	elif [ "$1" -eq "0" ];then
		pactl set-sink-mute jack_out toggle
	else
		pactl set-sink-volume jack_out +$1%
	fi
else
	if [ "$1" -lt "0" ];then
		amixer -D pulse sset Master $(echo $1 | sed -e 's/-//g')%-
	elif [ "$1" -eq "0" ];then
		amixer -D pulse sset Master toggle
	else
		amixer -D pulse sset Master $(echo $1 | sed -e 's/-//g')%+
	fi
fi
