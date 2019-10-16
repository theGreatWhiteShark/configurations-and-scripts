#!/bin/bash

## This script is intended to suspend the system into memory and to
## lock the screen when waking it up.

## -------------------------------------------------------------------

## As a nice screensaver, take a screenshot and blurs it.
scrot /tmp/screen_shot.png
mogrify -scale 20% -scale 500% /tmp/screen_shot.png

## -------------------------------------------------------------------

## Unmount the external hard disk.
if [ -d "/media/black/" ];then

	## If the clementine player is running, it probably plays back
	## some song from the hard disk. Thus, make it stop first.
	if [ "$(ps -aux | grep clementine | wc -l)" -gt 1 ];then
		clementine --stop
	fi

	## Actual unmounting.
	pumount /media/black
fi

## -------------------------------------------------------------------

## Suspend the system into memory
sudo pm-suspend

## -------------------------------------------------------------------

## If the external hard disk is plugged in, mount it.
if [ "$(ls /dev/disk/by-id/ | grep ata-TOSHIBA_MK1059GSM_11LNTERLT | wc -m)" -gt "0" ];then
	pmount /dev/disk/by-id/ata-TOSHIBA_MK1059GSM_11LNTERLT black
fi

## -------------------------------------------------------------------

## Lock the screen
i3lock -i /tmp/screen_shot.png

## -------------------------------------------------------------------

## turn of the monitor after a short delay
## using pgrep to NOT turn it of if unlocked in the short delay
sleep 60; pgrep i3lock && xset dpms force off
