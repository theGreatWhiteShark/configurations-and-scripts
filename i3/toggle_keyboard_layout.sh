#!/bin/bash

CURRENT_LAYOUT=$(setxkbmap -query | awk '/layout/{print $2}')

if [ "$CURRENT_LAYOUT" == "us" ]; then
	setxkbmap -layout de
else
	setxkbmap -layout us
fi
