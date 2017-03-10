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
alias eam='emacs -nw'
# Emacs with super user permissions
alias sema='sudo emacs -nw'
# Convenient way to debug your .bashrc
alias sbash='source $HOME/.bashrc; chmod +x -R $HOME/scripts/'
alias bashrc='emacs -nw $HOME/.bashrc; source $HOME/.bashrc'
# Display the size of all folders in a directory
alias duh='du --max-depth=1 -h'
# Shutdown/stop the audio with the least amount of characters.
# This is especially useful when you are connected via ssh from your smartphone
alias s='sudo shutdown -P'
alias sc='stop_clementine'
alias pp='sudo shutdown -P now'
# Link to the glorious JDownloader
alias jdownloader='~/.jd2/JDownloader2'

# Just execute this command whenever I am at a machine I configured myself
if [ $USER == "phil" ];then
    ## activating alternative keymap
    xmodmap ~/.xmodmap
fi

## Networks and servers
alias ipconfig='nmcli dev list iface eth0 | grep IP4'
alias locmap='nmap -n 192.168.178.1/50'
# Mount the home and data folders of the institute's cluster at my local computer
alias mpks='sshfs phmu@newton.mpipks-dresden.mpg.de:/home/phmu $HOME/pks_home; sshfs phmu@newton.mpipks-dresden.mpg.de:/data /data'
alias mpks_vesta='sshfs phmu@vesta.mpipks-dresden.mpg.de:/home/phmu $HOME/pks_home; sshfs phmu@vesta.mpipks-dresden.mpg.de:/data /data'
# Quick access to some frequently visited servers
alias newton='ssh phmu@newton.mpipks-dresden.mpg.de'
alias vesta='ssh phmu@vesta.mpipks-dresden.mpg.de'
alias jolly='ssh phmu@jolly.mpipks-dresden.mpg.de'
alias hermes='ssh phmu@hermes.mpipks-dresden.mpg.de'
alias makalu='ssh phmu9775@makalu250.rz.tu-ilmenau.de'
alias vpn='sudo vpnc /home/phil/.vpnc-extern.conf'
alias visit='ssh -X newton "ssh -X makalu /usr/app-soft/visit/visit2_7_1.linux-x86_64/bin/visit"'
alias fema='ssh -X feynman "emacs"';
alias ps6=print_with_ps6;

# Music
alias lmms='~/git/lmms/build/lmms'
alias hydrogen='~/git/hydrogen/build/src/gui/hydrogen'
alias drumgizmo='~/git/drumgizmo/drumgizmo/drumgizmo'

## R
alias R='$HOME/software/R/R-3.3.2/bin/R --quiet --no-save'
alias Rscript='$HOME/software/R/R-3.3.2/bin/Rscript'
alias Rinit='source $HOME/scripts/bash/Rinit.sh' # installation of the packages for a newly installed R distribution 
alias Sweave='$HOME/software/R/R-3.3.2/bin/Sweave'
alias Rb='R --resave-data CMD build'
alias Rc='R CMD check'
alias Ri='R --no-init-file CMD INSTALL'

## Git - some bad practice shortcut for my org-files collecting all sorts of information
alias cgit='cd $HOME/git/tsa'
alias pgit='tempdir=$(pwd); cd $HOME/git/tsa; git pull; if [ $(stat -c %Y ~/Dropbox/MobileOrg/smartphone.org) -gt $(stat -c %Y ./org/smartphone.org) ]; then cp $HOME/Dropbox/MobileOrg/smartphone.org $HOME/git/tsa/org/; fi; cd $tempdir'
alias ogit='tempdir=$(pwd); cd $HOME/git/tsa; git commit -am "org"; git push; cp org/private.org org/work.org org/software.org org/notes/algorithms-computation.org org/notes/papers.org ~/Dropbox/MobileOrg/; cd $tempdir'

## reduce prompt to the two latest folders if there are more than three folders displayed
function pwd_prompt {
    pwd | sed "s/\/home\/$(echo $USER)/\~/" | awk 'BEGIN { FS = "/" };{ if ( NF > 3 ) print $1"/.../"$(NF-1)"/"$NF ; else print $0}'
}
if [ $(hostname) == "temeluchus" ] || [ $(hostname) == "abyzou" ]; then
    if [ $HOME == "/root" ]; then
	export PS1="\e[1;31m\]\h\e[0m\]: \[\e[1;34m\]\$(pwd_prompt) \[\e[1;31m\]$\[\e[0m\] ";
    else
	export PS1="\h: \[\e[1;34m\]\$(pwd_prompt) \[\e[0;32m\]$\[\e[0m\] ";
    fi
else ## tell me when I'm not on my local machine but in the Hubert's cluster
    export PS1="\h: \[\e[1;32m\]\$(pwd_prompt) \[\e[0;32m\]$\[\e[0m\] ";
fi
# Configurations for setting up development environments
export EDITOR=/usr/bin/emacs
export AWKPATH="$HOME/git/configurations-and-scripts/awk"
export ANDROID_HOME="$HOME/software/android-sdk-linux"
export JAVA_HOME="$HOME/software/java/jdk1.8.0_121"
# Perl configuration
PATH="/home/phil/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/phil/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/phil/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/phil/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/phil/perl5"; export PERL_MM_OPT;

## handling of the batch job system at the institute
source $HOME/git/configurations-and-scripts/bash/job.sh
alias qjob=function_qjob
alias qs='qsub ./.job.sh'

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
if [ $( echo $PATH | awk 'BEGIN {ck=0};/android/ {ck=1};END {print ck}') == 0 ];then
    export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
fi
# For working with at I need to define such function
function stop_clementine {
    at now + $1 minutes -f ~/scripts/bash/at_clementine.sh
    return
}

## setting the verbosity of the shiny log files
export SHINY_LOG_LEVEL=TRACE

# my GPG key ID
export GPGKEY=0BF476DA
