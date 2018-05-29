#!/bin/bash

## Small bash script running whenever the JACKd sound server is shut
## down. (Jack2 version 1.9.10)
##
## On my laptop I will use the JACK system only when I record or
## manipulate audio. In all other instances I will rely on the
## PulseAudio system. Therefore, each time the JACK2d daemon is getting
## start up, QJackCtrl will run `pasusender -- jack_control start`.
## This will suspend PulseAudio.

## Halt the JACK audio server. Unfortunately the JACK server has to be
## stopped manually.
# jack_control stop

## Kill the PulseAudio server
# pulseaudio -k
## and restart it
# pulseaudio -D
## Set the default sink to the USB audio interface
pacmd set-default-sink 'alsa_output.usb-TEAC_Corporation_US-2x2-00.analog-stereo'
pacmd set-default-source 'alsa_input.usb-TEAC_Corporation_US-2x2-00.analog-stereo'
## Give the system time to settle down
sleep 2
## Restart the PulseAudio system tray (to update the changes)
killall pasystray
pasystray &
