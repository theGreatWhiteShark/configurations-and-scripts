#!/bin/bash
### En- or disables the touchpad

## Detect the xinput number which is assigned to the touchpad.
touchpadXinputNumber=$(xinput --list | awk '/TouchPad/{print $6}' | awk -F "=" '{print $2}')

## Current status of the touchpad: 0 - disabled, 1 - enabled
touchpadStatus=$(xinput --list-props $touchpadXinputNumber | awk '/Device Enabled/ {print $4}')

if [ $touchpadStatus == "1" ]; then
    ## Turn it off
    xinput --set-prop $touchpadXinputNumber "Device Enabled" 0
else
    ## Turn it on
    xinput --set-prop $touchpadXinputNumber "Device Enabled" 1
fi
