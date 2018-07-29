#!/bin/bash

## Small bash script running whenever the JACKd sound server is shut
## down. (Jack2 version 1.9.12)
##
## On my laptop I will use the JACK system only when I record or
## manipulate audio. In all other instances I will rely on the
## PulseAudio system. Therefore, each time the JACK2d daemon is getting
## start up, QJackCtrl will run `pasusender -- jackd`.
## This will suspend PulseAudio.

## Halt the JACK audio server. Unfortunately the JACK server has to be
## stopped manually.
killall jackd

## Now that the JACK server is terminated. The output of PulseAudio is
## reset to the external USB sound card.

## Since the precise device names may change, just the overall label
## of the sound card is set and the actual name will be queried.
soundCardName="US-2x2"
## Set the default sink to the USB audio interface
pacmd set-default-sink $(pacmd list-sinks | grep $soundCardName | grep output | sed 's/^[[:space:]]name: <//g; s/>//g')
pacmd set-default-source $(pacmd list-sources | grep $soundCardName | grep input | sed 's/^[[:space:]]name: <//g; s/>//g')

## Give the system time to settle down
sleep 2
## Restart the PulseAudio system tray (to update the changes)
killall pasystray
pasystray &
