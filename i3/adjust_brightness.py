#!/usr/bin/python3

# This script increases or decreases the brightness of all devices
# connected to the X11 server simultaneously. A signed percentage of
# brightness change has to be provided as input argument in the range
# of 0 to 1.

# Note: if `xbacklight` can be used to control both screens, do so!
# The xrandr brightness setting do not control the true brightness but
# just damp the three color channels (see `man xrandr`).

# The script stores the current brightness in the ~/.i3/brightness
# file. 

# Usage: ./adjust_brightness.py -0.1

import os
import subprocess
import string
import sys

# Since Python is just not capable to do things conveniently, one has
# to manually set the user home.
userHome = os.path.expanduser( "~" )

# Obtain the current value of the global brightness
if not os.path.isfile( userHome + "/.i3/brightness" ):
  # The file containing the global brightness value does not exist. So
  # it has to be initialized with 1 (100% brightness) 
  globalBrightness = 1
else:
  globalBrightnessFile = open( userHome + "/.i3/brightness", 'r' )
  globalBrightness = float( globalBrightnessFile.read() )
  globalBrightnessFile.close()

  # Discard the file.
  os.remove( userHome + "/.i3/brightness" )

# Adjust the brightness using the input value
globalBrightness += float( sys.argv[ 1 ] )

# Round the results, since Python is not able calculate properly.
# 0.9-0.1-0.1=0.7000000000000001 ????
globalBrightness = round( globalBrightness, 2 )

# Sanity checks. The global brightness has to be bound by 0 and 1
if globalBrightness > 1:
  globalBrightness = 1
if globalBrightness < 0:
  globalBrightness = 0

# Write the result in a new instance of the file containing the global
# value
globalBrightnessFile = open( userHome + "/.i3/brightness", 'w' )
globalBrightnessFile.write( str( globalBrightness ) )
globalBrightnessFile.close()

# Get a list of all active X11 devices
# Raw output
rawOutput = subprocess.check_output( ["xrandr", "--current"]
                                      ).decode( 'utf8' )
# All active devices have a leading newline '\n' and are followed by
# ' connected'
connectIndex = rawOutput.find( ' connected' )
devicesCount = 0 # Total number of active devices
devicesActive = [[]]

while ( connectIndex > 0 ):
  # If the find command at the bottom of the while loop does not find
  # an instance of ' connected' anymore, the function returns -1.
  newLineIndex = rawOutput.rfind( '\n', 0, connectIndex )
  devicesActive.append( rawOutput[ newLineIndex + 1 :
                                   connectIndex ] )
  devicesCount += 1
  # Search for the next occurrence of an active device in the output
  # of xrandr
  connectIndex = rawOutput.find( ' connected', connectIndex + 1 )

# The first element is an empty one and can be omitted
for ii in devicesActive[ 1 : ]:
  # Well, there is subprocess.call in Python 3.4 and subprocess.run in
  # Python 3.5. ... Next time I use Lua or Ruby...
  os.system( "xrandr --output " + ii + " --brightness " +
                   str( globalBrightness ) )

