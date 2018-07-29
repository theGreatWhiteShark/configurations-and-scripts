#!/bin/bash

## Since I'm not using the DBus interface of JACK in Devuan ASCII, I
## need to load the JACK sink and source first. With the DBus
## interface active PulseAudio will load them automatically.
pacmd load-module module-jack-sink
pacmd load-module module-jack-source

## Setting the JACK sink as the default sink of the Pulseaudio server.
pacmd set-default-sink 'jack_out'
pacmd set-default-source 'jack_in'
