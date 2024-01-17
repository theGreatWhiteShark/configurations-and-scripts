#!/bin/bash
## take a screen shot and blurs it
scrot --overwrite /tmp/screen_shot.png
mogrify -scale 10% -scale 1000% /tmp/screen_shot.png
i3lock -i /tmp/screen_shot.png
## turn of the monitor after a short delay
## using pgrep to NOT turn it of if unlocked in the short delay
sleep 60; pgrep i3lock && xset dpms force off
