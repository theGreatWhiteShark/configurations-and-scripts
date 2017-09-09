## Basics, navigation, and aliases
alias ll='ls -lah'
alias l='ls --color=auto'
alias ls='ls --color=auto'
alias cp='cp -a'
alias rm='rm -rf'
alias mroe='more'
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'
alias .....='cd ..; cd ..; cd ..; cd ..'
# Open Emacs in a shell
alias ema='emacs -nw'
alias eam='bin/emacs -nw'
# Emacs with super user permissions
alias sema='sudo /usr/bin/emacs -nw'
# Convenient way to debug your .bashrc
alias sbash='source $HOME/.bashrc'
alias bashrc='/usr/bin/emacs -nw $HOME/.bashrc; source $HOME/.bashrc'
# Display the size of all folders in a directory
alias duh='du --max-depth=1 -h'
# Shutdown/stop the audio with the least amount of characters.
# This is especially useful when you are connected via ssh from your smartphone
alias p='sudo shutdown -h'
alias s='stop_clementine'
alias pp='sudo shutdown -h now'
alias reboot='sudo /sbin/reboot'

## activating alternative keymap
xmodmap ~/.xmodmap

## Networks and servers
alias ipconfig='nmcli dev list iface eth0 | grep IP4'
alias locmap='nmap -n 192.168.178.1/50'

## reduce prompt to the two latest folders if there are more than three folders displayed
function pwd_prompt {
    pwd | sed "s/\/home\/$(echo $USER)/\~/" | awk 'BEGIN { FS = "/" };{ if ( NF > 3 ) print $1"/.../"$(NF-1)"/"$NF ; else print $0}'
}
if [ $HOME == "/root" ]; then
    export PS1="\e[1;31m\]\h\e[0m\]: \[\e[1;34m\]\$(pwd_prompt) \[\e[1;31m\]$\[\e[0m\] ";
else
    export PS1="\h: \[\e[1;34m\]\$(pwd_prompt) \[\e[0;32m\]$\[\e[0m\] ";
fi

# Configurations for setting up development environments
export EDITOR=/usr/bin/emacs
export AWKPATH="$HOME/git/configurations-and-scripts/awk"

## Only append those paths if they arn't already present
if [ $( echo $PATH | awk 'BEGIN {ck=0};/usr\/bin\/local/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:/usr/bin/local
fi
if [ $( echo $PATH | awk 'BEGIN {ck=0};/usr\/local/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:/usr/local
fi
if [ $( echo $PATH | awk 'BEGIN {ck=0};/usr\/bin/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:/usr/bin
fi
if [ $( echo $PATH | awk 'BEGIN {ck=0};/phil\/bin/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:$HOME/bin
fi
if [ $( echo $PATH | awk 'BEGIN {ck=0};/scripts\/bash/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:$HOME/git/configurations-and-scripts/bash
fi
if [ $( echo $PATH | awk 'BEGIN {ck=0};/scripts\/awk/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:$HOME/git/configurations-and-scripts/awk
fi
if [ $( echo $PATH | awk 'BEGIN {ck=0};/scripts\/python/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:$HOME/git/configurations-and-scripts/python
fi
if [ $( echo $PATH | awk 'BEGIN {ck=0};/^\/sbin/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:/sbin
fi
if [ $( echo $PATH | awk 'BEGIN {ck=0};/usr\/sbin/ {ck=1};END {print ck}') == 0 ];then
    PATH=$PATH:/usr/sbin
fi

# For working with at I need to define such function
function stop_clementine {
    at now + $1 minutes -f at_clementine.sh
    return
}
