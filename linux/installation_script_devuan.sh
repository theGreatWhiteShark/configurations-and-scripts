#!/bin/bash

## Configuration of the home environment. 
## Since most files are already contained in the git repository they just have to be linked properly.
# Emacs stuff
rm -r $HOME/.emacs $HOME/.emacs.d
ln -s $HOME/git/configurations-and-scripts/emacs/.emacs $HOME/.emacs
ln -s $HOME/git/configurations-and-scripts/emacs/.emacs.d $HOME/.emacs.d
# Bash and linux
rm $HOME/.bashrc $HOME/.xinitrc $HOME/.xprofile $HOME/.profile
ln -s $HOME/git/configurations-and-scripts/bash/.bashrc $HOME/.bashrc
ln -s $HOME/git/configurations-and-scripts/linux/.xinitrc $HOME/.xinitrc
ln -s $HOME/git/configurations-and-scripts/linux/.xprofile-abyzou $HOME/.xprofile
touch $HOME/.profile
# i3 window manager
ln -s $HOME/git/configurations-and-scripts/i3/.i3status.conf-abyzou $HOME/.i3status.conf
mkdir $HOME/.i3
ln -s $HOME/git/configurations-and-scripts/i3/config-abyzou $HOME/.i3/config
# Terminator setting
mkdir -p $HOME/.config/terminator
ln -s $HOME/git/configurations-and-scripts/linux/config/terminator/config $HOME/.config/terminator/config
mkdir $HOME/bin
export PATH=$HOME/bin:$PATH

## Compile the most recent Emacs version
sudo apt -y install autoconf make gcc g++ pkg-config libasound2-dev libgtk-3-dev libxpm-dev libgnutls28-dev libtiff5-dev libgif-dev libxml2-dev libotf-dev libgpm-dev libncurses5-dev libjansson-dev liblcms2-dev texinfo

git clone https://github.com/emacs-mirror/emacs.git $HOME/git/emacs
cd $HOME/git/emacs/
git checkout emacs-27.2
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
cd ../helm
make
cd ../company
make

## Install helpful packages
sudo apt -y install apt-file at nitrogen imagemagick pandoc scrot xinput xbacklight meld thunderbird clementine kupfer terminator pasystray pavucontrol ispell ingerman wngerman aspell-de htop nextcloud-desktop caja-nextcloud i3-wm i3blocks i3lock i3status borgbackup qasmixer qasconfig r-base pmount xcompmgr ack go-mtpfs vlc global info liblo-tools
sudo apt-file update

## Install audio-related packages (also to
## install corresponding packages)
sudo apt -y install ecasound libecasoundc-dev libcsound64-dev csound csound-utils csound-data ambdec pavumeter paprefs pulseaudio-module-jack

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
sudo apt -y install amb-plugins autotalent blepvco blop bs2b-ladspa calf-plugins cmt csladspa drumgizmo drumkv1-lv2 fil-plugins guitarix-ladspa guitarix-lv2 invada-studio-plugins-ladspa invada-studio-plugins-lv2 ir.lv2 jalv ladspalist lv2-dev mcp-plugins omins pd-plugin rev-plugins rubberband-ladspa ste-plugins swh-plugins swh-lv2 tap-plugins vco-plugins wah-plugins zam-plugins zynadd

## Compile and install hydrogen
sudo apt -y install libqt5xmlpatterns5-dev libarchive-dev libsndfile1-dev libasound2-dev liblo-dev libpulse-dev libcppunit-dev liblrdf0-dev liblash-compat-dev librubberband-dev libjack-jackd2-dev ccache cmake libtar-dev doxygen qttools5-dev-tools qtbase5-dev-tools qttools5-dev qtbase5-dev qtcreator xmlto xmlpo docbook
git clone https://github.com/hydrogen-music/hydrogen.git $HOME/git/hydrogen
cd $HOME/git/hydrogen
./build.sh mm
cd build
sudo make install

## Compile and install JACK2. (It has to be configured to NOT use
## systemd)
sudo apt -y install libeigen3-dev libopus-dev opus-tools  libsamplerate0-dev libdb-dev
git clone https://github.com/jackaudio/jack2.git $HOME/git/jack2
cd $HOME/git/jack2
git checkout v1.9.17
./waf configure --systemd=no --dbus --enable-pkg-config-dbus-service-dir
./waf build
sudo ./waf install

## Compile and install QJackCtl
git clone https://github.com/rncbc/qjackctl $HOME/git/qjackctl
cd $HOME/git/qjackctl/
git checkout qjackctl_0_9_2
./autogen.sh 
./configure --enable-jack-version=yes
make
sudo make install

## Compile and install the NON DAW
sudo apt -y install libsigc++-2.0-dev

git clone git@github.com:theGreatWhiteShark/non $HOME/git/non
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

## compile and install lsp plugins
sudo apt install -y libfltk1.3-dev libmxml-dev libfftw3-dev
git clone git://github.com/sadko4u/lsp-plugins $HOME/lsp-plugins
cd $HOME/lsp-plugins
make
sudo make install

## compile and install Yoshimi
git clone git://github.com/Yoshimi/yoshimi $HOME/git/yoshimi
cd $HOME/git/yoshimi
git checkout 2.0
cd src
cmake .
make
sudo make install

## compile and install ZPlugins
sudo apt install -y python3-setuptools guile-2.2-dev

git clone git://github.com/mesonbuild/meson $HOME/git/meson
cd $HOME/git/meson
git checkout 0.57.1
sudo python3 setup.py install

git clone git://github.com/ninja-build/ninja $HOME/git/ninja
cd $HOME/git/ninja
git checkout v1.10.2
./configure.py --bootstrap
cp ninja $HOME/bin

sudo apt install -y meson
git clone https://git.sr.ht/~alextee/zplugins $HOME/git/zplugins
cd $HOME/git/zplugins
git checkout v0.2.3
meson build
ninja -C build
sudo ninja -C build install

## compile and install ZRythm
sudo apt install -y gettext rubberband-cli cppcheck clang-tidy jq sphinx-common sphinx-intl sass-spec help2man texi2html libyaml-dev libgtksourceviewmm-3.0-dev libzstd-dev libpcre2-dev
git clone https://git.sr.ht/~alextee/zrythm $HOME/git/zrythm
cd $HOME/git/zrythm
git checkout v1.0.0-alpha.14.1.2
meson build
meson compile -C
sudo meson install -C build

## compile and install MuseScore
sudo apt install -y qtwebengine5-dev qtquickcontrols2-5-dev qml-module-qtquick-templates2 libmp3lame-dev libqt5svg5-dev
git clone https://github.com/musescore/MuseScore $HOME/git/MuseScore
cd $HOME/git/MuseScore
git checkout v3.6.2
cmake . -DBUILD_PORTAUDIO=OFF -DBUILD_PORTMIDI=OFF
sudo ln -f /bin/gzip /usr/bin/gzip
sudo ln -s /bin/ln /usr/bin/ln
make -j4
sudo make install

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
