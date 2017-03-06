#!/bin/bash
### En- or disables the touchpad

## Current status of the touchpad: 0 - disabled, 1 - enabled
statusTouchpad=$(xinput --list-props 12 | awk '/Device Enabled/ {print $4}')

if [ $statusTouchpad == "1" ]; then
    ## Turn it off
    xinput --set-prop 12 "Device Enabled" 0
else
    ## Turn it on
    xinput --set-prop 12 "Device Enabled" 1
fi
