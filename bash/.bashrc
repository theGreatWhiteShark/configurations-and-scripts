## Basics, navigation, and aliases
alias ll='ls -lAh'
alias l='ls --color=auto'
alias ls='ls --color=auto'
alias cp='cp -a'
alias rm='rm -rf'
alias ..='cd ..'
# Open Emacs in a shell
alias ema='emacs -nw'
# Emacs with super user permissions
alias sema='sudo emacs -nw'
# Display the size of all folders in a directory
alias duh='du --max-depth=1 -h'
# Shutdown/stop the audio with the least amount of characters.
# This is especially useful when you are connected via ssh from your smartphone
alias s='sudo shutdown -h'
alias sc='stop_clementine'
alias reboot='sudo /sbin/reboot'
# Link to the glorious JDownloader
alias bfg='java -jar $HOME/git/configurations-and-scripts/java/bfg-1.13.0.jar ';
# Use the my custom script to start up TuxGuitar with ZynAddSubFX and
# connect them both using JACK
alias tuxguitar='lua $HOME/git/tux2zyn/tux2zyn.lua'
# Just execute this command whenever I am at a machine I configured
# myself 
if [ "$USER" == "phil" ];then
    ## activating alternative keymap
    xmodmap ~/.xmodmap
    # Source my custom X11 configuration. But only if the screens are
    # not in their preferred output mode.
    # This is necessary since i3 doesn't source the .xprofile itself
    # (and we don't want to source it every time we are opening a shell)
    if [ "$(xrandr --current | grep *+ | wc -l)" -eq "0" ];then
       source ~/.xprofile
       i3 restart
       source ~/.xprofile
    fi
fi

# Mount the home and data folders of the institute's cluster at my local computer
alias mpks='sshfs phmu@newton.mpipks-dresden.mpg.de:/home/phmu $HOME/pks_home; sshfs phmu@newton.mpipks-dresden.mpg.de:/data /data'
# Quick access to some frequently visited servers
alias vpn='sudo /usr/sbin/openvpn --suppress-timestamps --nobind --config $HOME/.vpn_mpipks.conf --writepid /var/run/openvpn/vpn_mpipks.pid'

## Git - some bad practice shortcut for my org-files collecting all sorts of information
alias pgit='tempdir=$(pwd); cd $HOME/git/orga; git pull; cd $tempdir'
alias ogit='tempdir=$(pwd); cd $HOME/git/orga; git commit -am "org"; git push; cd $tempdir'

## Go
export GOPATH="$HOME/go"
# export GOROOT="$HOME/.go1.11"
# export GOROOT_BOOTSTRAP="$HOME/.go1.4"

## Lua
export LUALIB="$HOME/software/lua/lua-5.3.5/src"
export LUA_PATH="$HOME/.luarocks/share/lua/5.3/?.lua;$HOME/.luarocks/share/lua/5.3/?/init.lua;/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;/usr/local/lib/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua;$HOME/git/configurations-and-scripts/lua/?.lua"
export LUA_CPATH="$HOME/.luarocks/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/?.so;/usr/local/lib/lua/5.3/loadall.so;./?.so"
# Load some packages during the start-up of Lua
alias lua="$(which lua) -l 'inspect'"

## reduce prompt to the two latest folders if there are more than three folders displayed
function pwd_prompt {
    pwd | sed "s/\/home\/$(echo $USER)/\~/" | awk 'BEGIN { FS = "/" };{ if ( NF > 3 ) print $1"/.../"$(NF-1)"/"$NF ; else print $0}'
}
if [ "$(hostname)" == "temeluchus" ] || [ "$(hostname)" == "abyzou" ]; then
    if [ "$HOME" == "/root" ]; then
	export PS1="\e[1;31m\]\h\e[0m\]: \[\e[1;34m\]\$(pwd_prompt) \[\e[1;31m\]$\[\e[0m\] ";
    else
	export PS1="\h: \[\e[1;34m\]\$(pwd_prompt) \[\e[0;32m\]$\[\e[0m\] ";
    fi
else ## tell me when I'm not on my local machine but in the Hubert's cluster
    export PS1="\h: \[\e[0;33m\]\$(pwd_prompt) \[\e[0;32m\]$\[\e[0m\] ";
fi
# Configurations for setting up development environments
export EDITOR=/bin/nano
export AWKPATH="$HOME/git/configurations-and-scripts/awk"
export ANDROID_HOME="$HOME/software/android-sdk"

## Only append those paths if they arn't already present
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/usr\/bin/ {ck=1};END {print ck}')" -eq "0" ];then
    PATH=$PATH:/usr/bin
fi
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/usr\/local/ {ck=1};END {print ck}')" -eq "0" ];then
    PATH=/usr/local/bin:/usr/local/share$PATH
fi
if [ "$( echo $LD_LIBRARY_PATH | awk 'BEGIN {ck=0};/usr\/local\/lib/ {ck=1};END {print ck}')" -eq "0" ];then
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH
fi
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/phil\/bin/ {ck=1};END {print ck}')" -eq "0" ];then
    PATH=$HOME/bin:$PATH
fi
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/phil\/.local\/bin/ {ck=1};END {print ck}')" -eq "0" ];then
    PATH=$HOME/.local/bin:$PATH
fi
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/scripts/ {ck=1};END {print ck}')" -eq "0" ];then
    PATH=$HOME/git/configurations-and-scripts/bash:$HOME/git/configurations-and-scripts/awk:$HOME/git/configurations-and-scripts/python:$HOME/git/configurations-and-scripts/java:$PATH
fi
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/^\/sbin/ {ck=1};END {print ck}')" -eq "0" ];then
    PATH=$PATH:/sbin
fi
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/usr\/sbin/ {ck=1};END {print ck}')" -eq "0" ];then
    PATH=$PATH:/usr/sbin
fi
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/android/ {ck=1};END {print ck}')" -eq "0" ];then
    export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/25.0.3:$ANDROID_HOME/tools/bin
fi
## Binaries installed using Cabal
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/cabal/ {ck=1};END {print ck}')" -eq "0" ];then
    export PATH=$HOME/.cabal/bin:$PATH
fi
## Binaries installed using Go. The 'cargo' component from Rust'
## binaries messes up things and has to be covered.
if [ "$( echo $PATH | sed 's/cargo/XXX/g' | awk 'BEGIN {ck=0};/go\/bin/ {ck=1};END {print ck}')" -eq "0" ];then
    export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
fi
## Binaries installed using Lua
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/luarocks/ {ck=1};END {print ck}')" -eq "0" ];then
    export PATH=$HOME/.luarocks/bin:$PATH
fi
## Binaries installed using Ruby
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/.gem\/ruby/ {ck=1};END {print ck}')" -eq "0" ];then
    export PATH=$HOME/.gem/ruby/2.1.0/bin:$PATH
fi
## Binaries installed using Rust
if [ "$( echo $PATH | awk 'BEGIN {ck=0};/.cargo/ {ck=1};END {print ck}')" -eq "0" ];then
    export PATH=$HOME/.cargo/bin:$PATH
fi

# For working with at I need to define such function
function stop_clementine {
    at now + $1 minutes -f ~/git/configurations-and-scripts/bash/at_clementine.sh
    return
}

## setting the verbosity of the shiny log files
export SHINY_LOG_LEVEL=TRACE

# my GPG key ID
export GPGKEY=0xB9EB2795611A2033
# Use correct terminal
export GPG_TTY=$(tty)

## Use a system-wide GNU Global database
export GTAGSLIBPATH=$HOME/.gtags/

# added by travis gem
[ -f /home/phil/.travis/travis.sh ] && source /home/phil/.travis/travis.sh

# Load the custom configuration of individual computers.
[ -f $HOME/.profile ] && source $HOME/.profile

# export USE_CCACHE=1
# export CCACHE_COMPRESS=1
# export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
# export ANDROID_HOME="$HOME/software/android/sdk-tools-linux/"
# export PATH=$HOME/software/android/sdk-tools-linux/platform-tools:$HOME/software/android/sdk-tools-linux/tools:$HOME/software/android/sdk-tools-linux/tools/bin:$HOME/software/android/sdk-tools-linux/build-tools/25.0.3:$PATH

# Default search path for LADSPA audio plugins
export LADSPA_PATH=$HOME/.ladspa/:/usr/lib/ladspa/:/usr/local/lib/ladspa/
export LV2_PATH=$HOME/.lv2:/usr/lib/lv2/
