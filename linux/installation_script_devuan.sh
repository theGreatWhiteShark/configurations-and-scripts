#!/bin/bash

function paths_and_folders() {
	echo -e " * generating basic environment (linking scripts and creating folders)...\n"
	
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
	ln -s $HOME/git/configurations-and-scripts/i3/.i3status.conf-mastema $HOME/.i3status.conf
	mkdir $HOME/.i3
	ln -s $HOME/git/configurations-and-scripts/i3/config-mastema $HOME/.i3/config
	# Terminator setting
	mkdir -p $HOME/.config/terminator
	ln -s $HOME/git/configurations-and-scripts/linux/config/terminator/config $HOME/.config/terminator/config
	mkdir $HOME/bin
	export PATH=$HOME/bin:$PATH

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

}

function emacs_install() {
	echo -e " * install emacs...\n"
	## Compile the most recent Emacs version
	sudo apt -y install libasound2-dev libgtk-3-dev libxpm-dev libgnutls28-dev libtiff5-dev libgif-dev libxml2-dev libotf-dev libgpm-dev libncurses5-dev libjansson-dev liblcms2-dev texinfo

	git clone https://github.com/emacs-mirror/emacs.git $HOME/git/emacs
	cd $HOME/git/emacs/
	git checkout emacs-28
	./autogen.sh
	./configure
	make
	sudo make install

	## Load and compile the custom packages of Emacs
	## Enabling all Emacs submodules
	cd $HOME/git/configurations-and-scripts/emacs
	git submodule update --init --recursive
	cd org-mode
	make
	make autoloads
	cd ../ESS
	make
	cd ../helm
	make
	cd ../company
	make
}

function general_install() {
	echo -e " * general installation...\n"
	
	## Install helpful packages
	sudo apt -y install apt-file at nitrogen imagemagick pandoc scrot xinput brightnessctl meld thunderbird clementine terminator pasystray pavucontrol ispell ingerman wngerman aspell-de htop nextcloud-desktop caja-nextcloud i3-wm i3blocks i3lock i3status borgbackup qasmixer qasconfig r-base pmount xcompmgr ack go-mtpfs vlc global info liblo-tools autoconf make gcc g++ pkg-config ecasound libecasoundc-dev libcsound64-dev csound csound-utils csound-data ambdec pavumeter paprefs pulseaudio-module-jack synapse
	sudo apt-file update
}

function audio_install() {
	echo -e " * installing audio packages...\n"
	
	## Install LADSPA plugins
	sudo apt -y install amb-plugins autotalent blepvco blop bs2b-ladspa calf-plugins cmt csladspa drumgizmo drumkv1-lv2 fil-plugins guitarix-ladspa guitarix-lv2 invada-studio-plugins-ladspa invada-studio-plugins-lv2 ir.lv2 jalv ladspalist lv2-dev mcp-plugins omins pd-plugin rev-plugins rubberband-ladspa ste-plugins swh-plugins swh-lv2 tap-plugins vco-plugins wah-plugins zam-plugins zynadd
	
	## compile and install lsp plugins
	sudo apt install -y libfltk1.3-dev libmxml-dev libfftw3-dev
	git clone git://github.com/sadko4u/lsp-plugins $HOME/git/lsp-plugins
	cd $HOME/git/lsp-plugins
	git checkout 1.2.1
	make config FEATURES=’lv2 vst2 doc’
	make -j4
	sudo make install

	## compile and install Yoshimi
	git clone git://github.com/Yoshimi/yoshimi $HOME/git/yoshimi
	cd $HOME/git/yoshimi
	git checkout 2.2.0
	cd src
	cmake .
	Make -j4
	sudo make install

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

	## install Muse4
	git clone git://github.com/muse-sequencer/muse $HOME/git/muse
	cd $HOME/git/muse/src
	git checkout 4.1.0
	./compile_muse.sh
	cd build
	sudo make install

}

function hydrogen_install() {
	echo -e " * install everything required to compile hydrogen...\n"
	## Compile and install hydrogen
	sudo apt -y install libqt5xmlpatterns5-dev libarchive-dev libsndfile1-dev libasound2-dev liblo-dev libpulse-dev libcppunit-dev liblrdf0-dev liblash-compat-dev librubberband-dev libjack-jackd2-dev ccache cmake libtar-dev doxygen qttools5-dev-tools qtbase5-dev-tools qttools5-dev qtbase5-dev qtcreator xmlto xmlpo docbook
	git clone https://github.com/hydrogen-music/hydrogen.git $HOME/git/hydrogen
	cd $HOME/git/hydrogen
	./build.sh mm
	cd build
	sudo make install
}

function jack2_install() {
	echo -e " * install JACK2...\n"
	
	## Compile and install JACK2. (It has to be configured to NOT use
	## systemd)
	sudo apt -y install libeigen3-dev libopus-dev opus-tools  libsamplerate0-dev libdb-dev
	git clone https://github.com/jackaudio/jack2.git $HOME/git/jack2
	cd $HOME/git/jack2
	git checkout v1.9.21
	./waf configure --systemd=no --dbus --enable-pkg-config-dbus-service-dir
	./waf build
	sudo ./waf install

	## Compile and install QJackCtl
	git clone https://github.com/rncbc/qjackctl $HOME/git/qjackctl
	cd $HOME/git/qjackctl/
	git checkout qjackctl_0_9_7
	cmake -DCONFIG_JACK_VERSION=yes -B build
	cmake --build build --parallel 4
	sudo cmake --install build
}

echo -e "Installation script written for Devuan Chimaera (last updated 2022.05.18)\n"

read -p "Installing audio libraries (apart from hydrogen) as well? [y/n] " AUDIO_REQUESTED 

paths_and_folders
general_install
emacs_install
jack2_install
hydrogen_install

if [ "$AUDIO_REQUESTED" == "y" ]; then
	audio_install
fi

## Final update
sudo apt update
sudo apt -y upgrade
sudo apt-get autoremove
sudo apt-file update
