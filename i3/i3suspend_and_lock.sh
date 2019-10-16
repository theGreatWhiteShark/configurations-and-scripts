#!/bin/bash

## This script is intended to suspend the system into memory and to
## lock the screen when waking it up.

## -------------------------------------------------------------------

## As a nice screensaver, take a screenshot and blurs it.
scrot /tmp/screen_shot.png
mogrify -scale 20% -scale 500% /tmp/screen_shot.png

## -------------------------------------------------------------------

## Suspend the system into memory
sudo pm-suspend

## -------------------------------------------------------------------

## Lock the screen
i3lock -i /tmp/screen_shot.png

## -------------------------------------------------------------------

## turn of the monitor after a short delay
## using pgrep to NOT turn it of if unlocked in the short delay
sleep 60; pgrep i3lock && xset dpms force off
