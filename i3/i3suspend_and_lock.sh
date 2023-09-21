#!/bin/bash

## This script is intended to suspend the system into memory and to
## lock the screen when waking it up.

## -------------------------------------------------------------------

## Switch back to English layout so I can get the password right
setxkbmap -layout us

## -------------------------------------------------------------------

## As a nice screensaver, take a screenshot and blurs it.
scrot /tmp/screen_shot.png
mogrify -scale 20% -scale 500% /tmp/screen_shot.png

## -------------------------------------------------------------------

## Suspend the system into memory
loginctl suspend

## -------------------------------------------------------------------

## Lock the screen
i3lock -i /tmp/screen_shot.png
