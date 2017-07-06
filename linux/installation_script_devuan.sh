#!/bin/bash

## Gaining of root privileges
sudo -i

## Configuration of the home environment. 
## Since most files are already contained in the git repository they just have to be linked properly.
# Emacs stuff
rm -r $HOME/.emacs $HOME/.emacs.d
ln -s $HOME/git/configurations-and-scripts/emacs/.emacs $HOME/.emacs
ln -s $HOME/git/configurations-and-scripts/emacs/.emacs.d $HOME/.emacs.d
# Bash and linux
rm $HOME/.bashrc $HOME/.xinitrc $HOME/.xprofile $HOME/.xmodmap
ln -s $HOME/git/configurations-and-scripts/bash/.bashrc $HOME/.bashrc
ln -s $HOME/git/configurations-and-scripts/linux/.xinitrc $HOME/.xinitrc
ln -s $HOME/git/configurations-and-scripts/linux/.xprofile $HOME/.xprofile
ln -s $HOME/git/configurations-and-scripts/linux/.xmodmap $HOME/.xmodmap
# R
ln -as $HOME/git/configurations-and-scripts/R/.Rprofile $HOME/.Rprofile
# i3 window manager
ln -s $HOME/git/configurations-and-scripts/i3/.i3status.conf-temeluchus $HOME/.i3status.conf
mkdir $HOME/.i3
ln -s $HOME/git/configurations-and-scripts/i3/config-temeluchus $HOME/.i3/config

## Make directories required for mounting my institut's home via sshfs
sudo mkdir /data
sudo chmod a+xw /data
mkdir pks_home

## Installation of required packages

# Autoaccept the licenses
sudo apt-get -y install ttf-mscorefonts-installer --quiet
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
preseed --owner ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true sshfs
 xcompmgr meld apt-file bzip2 libbz2-dev liblzma-dev libjpeg8-dev libtiff5-dev thunar unity-greeter-badges mate-terminal npm

sudo apt -y install gfortran fort77 texlive xorg-dev texlive-fonts-extra texinfo default-jre default-jre-headless default-jdk texlive-latex-extra intltool emacs24 multitail libreadline6 libreadline6-dev libreadline6-dbg hunspell g++ emacs-goodies-el global sshfs apt-file libcairo2-dev libssh-dev libcurl4-gnutls-dev libxml2-dev i3 i3-wm at i3status i3lock nitrogen imagemagick pandoc scrot xinput xbacklight xcompmgr meld apt-file bzip2 libbz2-dev liblzma-dev libtiff5-dev mate-terminal npm


## Disabling the amazon-unity lens
# wget -q -O - https://fixubuntu.com/fixubuntu.sh | bash

## Enabling all Emacs submodules
cd $HOME/git/configurations-and-scripts/emacs
git submodule update --init --recursive --remote
cd org-mode
make
make autoloads
sudo make install
cd ../ESS
make
sudo make install

## R
mkdir $HOME/software/R
cd $HOME/software/R
wget https://cran.r-project.org/src/base/R-3/R-3.4.0.tar.gz
tar -xf R-3.4.0.tar.gz
rm R-3.4.0.tar.gz 
cd $HOME/software/R/R-3.4.0
./configure
make
sudo make install
rm 

Rscript --no-init-file -e "options( repos = 'https://cran.uni-muenster.de/'); source( '~/git/configurations-and-scripts/R/package_installation.R' )"

## other additional software
sudo add-apt-repository -y ppa:me-davidsansome/clementine

apt-file update
sudo apt update
sudo apt -y install clementine

sudo apt -y upgrade
sudo apt autoremove
sudo apt-file update
exit
