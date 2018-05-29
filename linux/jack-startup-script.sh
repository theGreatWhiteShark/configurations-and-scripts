#!/bin/bash

## Setting the JACK sink as the default sink of the Pulseaudio server.
pacmd set-default-sink 'jack_out'
pacmd set-default-source 'jack_in'
