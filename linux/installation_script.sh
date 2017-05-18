#!/bin/bash

## Gaining of root privileges
sudo -i

## Configuration of the home environment. Therefore this script has to be located in the same directory like the .bashrc, .emacs and .elisp script!
mkdir -p $HOME/.emacs.d/cache
mkdir $HOME/software
mkdir $HOME/pks_home
cp ./.bashrc $HOME/.bashrc
cp ./.emacs $HOME/.emacs
cp ./.Rprofile $HOME/.Rprofile
cp -r ./i3 $HOME/.i3
cp .i3status.conf $HOME/.i3status.conf
cp -r $HOME/git/tsa/scripts $HOME/scripts
mv $HOME/scripts/elisp $HOME/.elisp

sudo mkdir /data
sudo chmod a+xw /data

## Installation of required packages

# Autoaccept the licenses
sudo apt-get -y install ttf-mscorefonts-installer --quiet
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
preseed --owner ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula boolean true sshfs

sudo apt-get -y install gfortran fort77 texlive xorg-dev texlive-fonts-extra texinfo default-jre gcj-4.8-jre-headless openjdk-7-jre-headless openjdk-6-jre-headless texlive-latex-extra intltool ^ubuntu-restricted-* emacs24 multitail konsole libreadline6 libreadline6-dev libreadline6-dbg hunspell gnome-wallpaper-* ubuntu-wallpaper-* g++ vlc emacs-goodies-el global sshfs apt-file libcairo2-dev libssh-dev compiz-plugins libcurl4-gnutls-dev libxml2-dev i3 i3-wm at i3status i3lock nitrogen imagemagick pandoc scrot xinput xbacklight xcompmgr
## Disabling the amazon-unity lens
wget -q -O - https://fixubuntu.com/fixubuntu.sh | bash

## R
cd $HOME/software
wget http://cran.r-mirror.de/src/base/R-3/R-3.2.3.tar.gz
tar -xf R-3.2.3.tar.gz 
cd $HOME/software/R-3.2.3
./configure
make
sudo make install

Rscript --no-init-file -e "options( repos = 'https://cran.uni-muenster.de/'); source( '~/scripts/R/package_installation.R' )"

## configuring emacs
cd $HOME/git

mkdir emacs-spass
cd $HOME/git/emacs-spass
git clone git://repo.or.cz/anything-config.git
git clone https://github.com/emacs-jp/elscreen
git clone https://github.com/emacs-ess/ESS
git clone https://github.com/victorhge/iedit
git clone https://github.com/dandavison/minimal.git
git clone git://orgmode.org/org-mode.git
git clone --recursive https://github.com/theGreatWhiteShark/yasnippet my-yasnippet
git clone https://github.com/bbatsov/zenburn-emacs.git
git clone https://github.com/theGreatWhiteShark/polymode my-polymode
git clone https://github.com/theGreatWhiteShark/org-reveal my-org-reveal

cd $HOME/git/emacs-spass/org-mode/
make
sudo make install
cd $HOME/git/emacs-spass/ESS/
make
sudo make install

## Xscreensaver
# cd $HOME/software
# wget http://www.jwz.org/xscreensaver/xscreensaver-5.32.tar.gz
# tar -xf xscreensaver-5.32.tar.gz 
# cd $HOME/software/xscreensaver-5.32
# ./configure
# make
# sudo make install

## other additional software
sudo add-apt-repository -y ppa:me-davidsansome/clementine

apt-file update
sudo apt-get update
sudo apt-get -y install clementine

sudo apt-get -y upgrade
sudo apt-get autoremove
exit
