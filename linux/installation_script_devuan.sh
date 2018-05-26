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
ln -s $HOME/git/configurations-and-scripts/linux/.xprofile $HOME/.xprofile-abyzou
ln -s $HOME/git/configurations-and-scripts/linux/.xmodmap $HOME/.xmodmap
touch $HOME/.profile
# R
ln -as $HOME/git/configurations-and-scripts/R/.Rprofile $HOME/.Rprofile
# i3 window manager
ln -s $HOME/git/configurations-and-scripts/i3/.i3status.conf-temeluchus $HOME/.i3status.conf
mkdir $HOME/.i3
ln -s $HOME/git/configurations-and-scripts/i3/config-temeluchus $HOME/.i3/config
# Terminator setting
mkdir -p $HOME/.config/terminator
ln -s $HOME/git/configurations-and-scripts/linux/.config/terminator/config $HOME/.config/terminator/config

## Make directories required for mounting my institut's home via sshfs
sudo mkdir /data
sudo chmod a+xw /data
mkdir ~/pks_home

## Include the Nextcloud repositories
echo 'deb http://download.opensuse.org/repositories/home:/ivaradi/Debian_8.0/ /' > nextcloud-client.list
sudo mv ./nextcloud-client.list /etc/apt/sources.list.d/
wget -q -O - http://download.opensuse.org/repositories/home:/ivaradi/Debian_8.0/Release.key > nextcloud.key
sudo apt-key add ./nextcloud.key
rm ./nextcloud.key
sudo apt update

## Compile the most recent Emacs version
sudo apt -y install autoconf make gcc g++ pkg-config libasound2-dev libgtk-3-dev libxpm-dev libgnutls28-dev libtiff5-dev libgif-dev libxml2-dev libotf-dev libgpm-dev libncurses5-dev libjansson-dev liblcms2-dev 

git clone https://github.com/emacs-mirror/emacs.git $home/git/emacs
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
sudo apt -y install apt-file sshfs at nitrogen imagemagick pandoc scrot xinput xbacklight xcompmgr meld lshw thunderbird thunar clementine kupfer terminator wicd-gtk pasystray pavucontrol ispell ingerman wngerman aspell-de htop
sudo apt-file update


## Installation of required packages
sudo apt -y install xorg-dev texlive-fonts-extra texinfo default-jre default-jre-headless default-jdk texlive-latex-extra intltool emacs24 multitail libreadline6 libreadline6-dev libreadline6-dbg hunspell g++ emacs-goodies-el global sshfs apt-file libcairo2-dev libssh-dev libcurl4-gnutls-dev libxml2-dev


## Setting up the R environment
sudo apt -y install gfortran fort77 texlive texlive-fonts-extra libreadline-dev xorg-dev default-jdk libzip-dev lbzip2 libbz2-dev

mkdir $HOME/software/R
cd $HOME/software/R
wget https://cran.r-project.org/src/base/R-3/R-3.5.0.tar.gz
tar -xf R-3.5.0.tar.gz
rm R-3.5.0.tar.gz 
cd $HOME/software/R/R-3.5.0
./configure
make
sudo make install

Rscript --no-init-file -e "options( repos = 'https://cran.uni-muenster.de/'); source( '~/git/configurations-and-scripts/R/package_installation.R' )"


## Install audio-related packages (also to
## install corresponding packages)
sudo apt -y install qt5-default libqt5xmlpatterns5-dev libarchive-dev libsndfile1-dev libasound2-dev liblo-dev libpulse-dev libcppunit-dev liblrdf0-dev liblash-compat-dev librubberband-dev ecasound libecasoundc-dev libcsound64-dev csound csound-utils csound-data tuxguitar tuxguitar-alsa tuxguitar-fluidsynth tuxguitar-jack libjack-jackd2-dev ccache cmake supercollider

## Install LADSPA plugins
sudo apt -y amb-plugins autotalent blepvco blop bs2b-ladspa calf-ladspa cmt csladspa fil-plugins guitarix-ladspa invada-studio-plugins-ladspa ladspalist mcp-plugins omins pd-plugin rev-plugins rubberband-ladspa ste-plugins swh-plugins tap-plugins vco-plugins wah-plugins zam-plugins



## Final update
sudo apt update
sudo apt -y upgrade
sudo apt-get autoremove
sudo apt-file update
exit
