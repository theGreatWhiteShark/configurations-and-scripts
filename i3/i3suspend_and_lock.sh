#!/bin/bash

## This script is intended to suspend the system into memory and to
## lock the screen when waking it up.

## -------------------------------------------------------------------

## As a nice screensaver, take a screenshot and blurs it.
scrot /tmp/screen_shot.png
mogrify -scale 20% -scale 500% /tmp/screen_shot.png

## -------------------------------------------------------------------

## Unmount the external hard disk.
if [ -d "/media/black/music" ];then

	## If the clementine player is running, it probably plays back
	## some song from the hard disk. Thus, make it stop first.
	if [ "$(ps -aux | grep clementine | wc -l)" -gt 1 ];then
		## Running pause first to immediately stop the player without
		## triggering a fadeout.
		clementine --pause
		clementine --stop
	fi

	## ---------------------------------------------------------------

	## Actual unmounting.
	##
	## This can take a while depending on what clementine is
	## doing. Let's give it some tries. I total it waits for 8
	## seconds.
	for ii in {1..10};do
		pumount /media/black &> /dev/null

		## Check whether the unmounting was successful.
		if [ $? -eq 0 ];then
			break
		fi

		## Was not successful yet. Let's wait and try again.
		sleep 0.9

		if [ "$ii" -eq "10" ];then
			## Well, fuck it. Let's kill all commands accessing the
			## hard disk.
			for ii in $(lsof +D ~/Downloads/ -a -u$USER +c 0 | 	awk 'NR>1 {print $1}');do
				killall $ii;
			done

			## Let's wait five more seconds for everything to settle
			## and call pumount again. But this time without
			## discarding its output.
			pumount /media/black
		fi

	done
fi

## -------------------------------------------------------------------

## Suspend the system into memory
systemctl suspend

## -------------------------------------------------------------------

## Lock the screen
i3lock -i /tmp/screen_shot.png

## -------------------------------------------------------------------

## If the external hard disk is plugged in, mount it.
source ~/.profile
