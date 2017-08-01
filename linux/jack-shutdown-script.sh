#!/bin/bash

## Small bash script running whenever the JACKd sound server is shut
## down. (Jack2 version 1.9.10)
##
## On my laptop I will use the JACK system only when I record or
## manipulate audio. In all other instances I will rely on the
## PulseAudio system. Therefore, each time the JACKd daemon is getting
## start up, QJackCtrl will run `pasusender -- jackd`. This will
## suspend PulseAudio.

## Kill the PulseAudio server
pulseaudio -k
killall pulseaudio
## and restart it
pulseaudio -D
