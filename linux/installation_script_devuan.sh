#!/bin/bash

## Configuration of the home environment. 
## Since most files are already contained in the git repository they just have to be linked properly.
# Emacs stuff
rm -r $HOME/.emacs $HOME/.emacs.d
ln -s $HOME/git/configurations-and-scripts/emacs/.emacs $HOME/.emacs
ln -s $HOME/git/configurations-and-scripts/emacs/.emacs.d $HOME/.emacs.d
# Bash and linux
rm $HOME/.bashrc $HOME/.xinitrc $HOME/.xprofile $HOME/.xmodmap $HOME/.profile
ln -s $HOME/git/configurations-and-scripts/bash/.bashrc $HOME/.bashrc
ln -s $HOME/git/configurations-and-scripts/linux/.xinitrc $HOME/.xinitrc
ln -s $HOME/git/configurations-and-scripts/linux/.xprofile-abyzou $HOME/.xprofile
ln -s $HOME/git/configurations-and-scripts/linux/.xmodmap $HOME/.xmodmap
touch $HOME/.profile
# R
ln -s $HOME/git/configurations-and-scripts/R/.Rprofile $HOME/.Rprofile
# i3 window manager
ln -s $HOME/git/configurations-and-scripts/i3/.i3status.conf-abyzou $HOME/.i3status.conf
mkdir $HOME/.i3
ln -s $HOME/git/configurations-and-scripts/i3/config-abyzou $HOME/.i3/config
# Terminator setting
mkdir -p $HOME/.config/terminator
ln -s $HOME/git/configurations-and-scripts/linux/config/terminator/config $HOME/.config/terminator/config

## Make directories required for mounting my institut's home via sshfs
sudo mkdir /data
sudo chmod a+xw /data
mkdir ~/pks_home

## Include the Nextcloud repositories
echo 'deb http://download.opensuse.org/repositories/home:/ivaradi/Debian_9.0/ /' > nextcloud-client.list
sudo mv ./nextcloud-client.list /etc/apt/sources.list.d/
wget -q -O - http://download.opensuse.org/repositories/home:/ivaradi/Debian_9.0/Release.key > nextcloud.key
sudo apt-key add ./nextcloud.key
rm ./nextcloud.key
sudo apt update

## Compile the most recent Emacs version
sudo apt -y install autoconf make gcc g++ pkg-config libasound2-dev libgtk-3-dev libxpm-dev libgnutls28-dev libtiff5-dev libgif-dev libxml2-dev libotf-dev libgpm-dev libncurses5-dev libjansson-dev liblcms2-dev texinfo

git clone https://github.com/emacs-mirror/emacs.git $HOME/git/emacs
cd $HOME/git/emacs/
./autogen.sh
./configure
make
sudo make install

## Load and compile the custom packages of Emacs
## Enabling all Emacs submodules
cd $HOME/git/configurations-and-scripts/emacs
git submodule update --init --recursive --remote
cd org-mode
make
make autoloads
cd ../ESS
make

## Install helpful packages
sudo apt -y install apt-file sshfs at nitrogen imagemagick pandoc scrot xinput xbacklight xcompmgr meld lshw thunderbird thunar clementine kupfer terminator wicd-gtk pasystray pavucontrol ispell ingerman wngerman aspell-de htop nextcloud-client i3-wm i3blocks i3lock i3status
sudo apt-file update


## Installation of required packages for R
sudo apt -y install xorg-dev texlive-fonts-extra default-jre default-jre-headless default-jdk texlive-latex-extra intltool multitail libreadline7 libreadline-dev hunspell g++ global libcairo2-dev libssh-dev libcurl4-gnutls-dev libxml2-dev gfortran fort77 texlive libzip-dev lbzip2 libbz2-dev libprotobuf-dev libv8-3.14-dev libgdal-dev gdal-bin libproj-dev libudunits2-dev libnetcdf-dev netcdf-bin libjq-dev protobuf-compiler

mkdir -p $HOME/software/R
cd $HOME/software/R
wget https://cran.r-project.org/src/base/R-3/R-3.5.0.tar.gz
tar -xf R-3.5.0.tar.gz
rm R-3.5.0.tar.gz 
cd $HOME/software/R/R-3.5.0
./configure
make
sudo make install

# This script will install a bunch of R libraries to get you
# started. But it most probably won't work since the user has to agree
# to install the libraries locally first.
Rscript --no-init-file -e "options( repos = 'https://cran.uni-muenster.de/'); source( '~/git/configurations-and-scripts/R/package_installation.R' )"


## Install audio-related packages (also to
## install corresponding packages)
sudo apt -y install ecasound libecasoundc-dev libcsound64-dev csound csound-utils csound-data tuxguitar tuxguitar-alsa tuxguitar-fluidsynth tuxguitar-jack supercollider ambdec pavumeter paprefs pulseaudio-module-jack

## Link audio configuration files
[ -f $HOME/.ambdecrc ] && rm $HOME/.ambdecrc
[ -f $HOME/.ambdec-config-stereo ] && rm $HOME/.ambdec-config-stereo
mkdir $HOME/.config/pulse
mkdir $HOME/.config/rncbc.org

ln -s $HOME/git/configurations-and-scripts/linux/.ambdecrc $HOME/.ambdecrc
ln -s $HOME/git/configurations-and-scripts/linux/.ambdec-config-stereo $HOME/.ambdec-config-stereo
ln -s $HOME/git/configurations-and-scripts/linux/config/pulse/client.conf $HOME/.config/pulse/client.conf
ln -s $HOME/git/configurations-and-scripts/linux/config/pulse/default.pa $HOME/.config/pulse/default.pa
ln -s $HOME/git/configurations-and-scripts/linux/config/rncbc.org/QjackCtl.conf $HOME/.config/rncbc.org/QjackCtl.conf

## Install LADSPA plugins
sudo apt -y install amb-plugins autotalent blepvco blop bs2b-ladspa calf-ladspa cmt csladspa fil-plugins guitarix-ladspa invada-studio-plugins-ladspa ladspalist mcp-plugins omins pd-plugin rev-plugins rubberband-ladspa ste-plugins swh-plugins tap-plugins vco-plugins wah-plugins zam-plugins

## Compile and install hydrogen
sudo apt -y install qt5-default libqt5xmlpatterns5-dev libarchive-dev libsndfile1-dev libasound2-dev liblo-dev libpulse-dev libcppunit-dev liblrdf0-dev liblash-compat-dev librubberband-dev libjack-jackd2-dev ccache cmake libtar-dev doxygen qttools5-dev-tools
git clone https://github.com/hydrogen-music/hydrogen.git $HOME/git/hydrogen
cd $HOME/git/hydrogen
./build.sh mm
cd build
sudo make install

## Compile and install JACK2. (It has to be configured to NOT use
## systemd)
sudo apt -y install libeigen3-dev libopus-dev opus-tools  libsamplerate0-dev install libdb-dev
git clone https://github.com/jackaudio/jack2.git $HOME/git/jack2
cd $HOME/git/jack2
./waf configure --systemd=no
./waf build
sudo ./waf install

## Compile and install QJackCtl
git clone https://github.com/rncbc/qjackctl $HOME/git/qjackctl
cd $HOME/qjackctl/
./autogen.sh 
./configure --enable-jack-version=yes --enable-dbus=no
make
sudo make install

## Compile and install the NON DAW
sudo apt -y install libsigc++-2.0-dev

git clone git://git.tuxfamily.org/gitroot/non/non.git $HOME/git/non
cd $HOME/git/non
git submodule update --init --recursive
cd lib/ntk
./waf configure
./waf
sudo ./waf install
cd ../..
./waf configure
./waf
sudo ./waf install

## building and configuring mutt
sudo apt install mutt postfix libncursesw5-dev libgpgme-dev gpgsm dirmngr gnupg2 libdb-dev pass
sudo apt-mark auto gpgsm dirmngr
cd $HOME/software
wget ftp://ftp.mutt.org/pub/mutt/mutt-1.11.2.tar.gz
tar -xf mutt-1.11.2.tar.gz
cd mutt-1.11.2
./prepare
./configure --enable-pgp --enable-gpgme --enable-compressed --enable-hcache --enable-smtp --enable-imap --enable-sidebar --with-gnutls --with-curses=/usr/lib/x86_64-linux-gnu/
make
sudo make install
cd $HOME/git/configurations-and-scripts/mutt/
gpg2 --decrypt --output account.0 account.0.asc
gpg2 --decrypt --output account.1 account.1.asc
gpg2 --decrypt --output account.2 account.2.asc
gpg2 --decrypt --output aliases aliases.asc
gpg2 --decrypt --output mailing.lists.and.groups mailing.lists.and.groups.asc

mkdir $HOME/.mutt
ln -s $HOME/git/configurations-and-scripts/mutt/account.0 $HOME/.mutt/account.0
ln -s $HOME/git/configurations-and-scripts/mutt/account.1 $HOME/.mutt/account.1
ln -s $HOME/git/configurations-and-scripts/mutt/account.2 $HOME/.mutt/account.2
ln -s $HOME/git/configurations-and-scripts/mutt/aliases $HOME/.mutt/aliases
ln -s $HOME/git/configurations-and-scripts/mutt/mailing.lists.and.groups $HOME/.mutt/mailing.lists.and.groups
ln -s $HOME/git/configurations-and-scripts/mutt/colors $HOME/.mutt/colors
ln -s $HOME/git/configurations-and-scripts/mutt/gpg.rc $HOME/.mutt/gpg.rc
ln -s $HOME/git/configurations-and-scripts/mutt/muttrc $HOME/.mutt/muttrc
ln -s $HOME/git/configurations-and-scripts/emacs/.emacs-mutt $HOME/.mutt/.emacs-mutt
# Setup the postfix server for outgoing mail
cd $HOME/git/configurations-and-scripts/linux/postfix/
gpg2 --decrypt --output sasl_passwd sasl_passwd.asc
gpg2 --decrypt --output sender_relay sender_relay.asc
sudo cp /etc/postfix/main.cf /etc/postfix/main.cf.backup
sudo cp /etc/postfix/main.cf /etc/postfix/old.main.cf
sudo cp $HOME/git/configurations-and-scripts/linux/postfix/main.cf /etc/postfix/
sudo cp $HOME/git/configurations-and-scripts/linux/postfix/sasl_passwd /etc/postfix/
sudo cp $HOME/git/configurations-and-scripts/linux/postfix/sender_relay /etc/postfix/

## Final update
sudo apt update
sudo apt -y upgrade
sudo apt-get autoremove
sudo apt-file update
exit
