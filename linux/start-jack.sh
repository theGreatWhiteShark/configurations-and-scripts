#!/bin/bash

## Script to start-up the DBUS version of JACK2 (version 1.9.10).
## I used https://wiki.archlinux.org/index.php/JACK_Audio_Connection_Kit
## for inspiration.

jack_control start # Start the JACK server (if not started already)
jack_control ds alsa # Use the ALSA drivers of the Linux kernel
jack_control dps device hw:US2x2 # Pick the right sound card
jack_control dps rate 48000 # Set the sample rate
jack_control dps nperiods 3 # Use three periods (since I'm using USB)
# Since I do not use monitoring, I can live with a high period number
jack_control dps period 1024 # Number of periods per frame
sleep 1 # pause. Let the startup to do its work to don't run in non-
         # deterministic error messages.
qjackctl & # For handling the connections to JACK
sleep 1
ardour & # For recording audio
sleep 1
hydrogen & # Sequencer and synthesizer of drum sounds
