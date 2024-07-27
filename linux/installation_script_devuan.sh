#!/bin/bash

function paths_and_folders() {
	echo -e "\n * generating basic environment (linking scripts and creating folders)...\n"
	
	cd $HOME/git/configurations-and-scripts || exit 1
	git submodule update --init --recursive || exit 1
	cd - || exit 1
	
	## Configuration of the home environment. 
	## Since most files are already contained in the git repository they just have to be linked properly.
	# Emacs stuff
	ln -s $HOME/git/configurations-and-scripts/emacs/.doom.d $HOME/.doom.d
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

	# sudo mv /etc/slim.conf /etc/slim.old.conf
	# sudo cp $HOME/git/configurations-and-scripts/linux/slim.conf /etc/slim.conf

	## Link audio configuration files
	[ -f $HOME/.ambdecrc ] && rm $HOME/.ambdecrc
	[ -f $HOME/.ambdec-config-stereo ] && rm $HOME/.ambdec-config-stereo
	[ -d $HOME/.config/pulse ] && rm -rf $HOME/.config/pulse
	mkdir $HOME/.config/pulse
	mkdir $HOME/.config/rncbc.org

	ln -s $HOME/git/configurations-and-scripts/linux/.ambdecrc $HOME/.ambdecrc
	ln -s $HOME/git/configurations-and-scripts/linux/.ambdec-config-stereo $HOME/.ambdec-config-stereo
	ln -s $HOME/git/configurations-and-scripts/linux/config/pulse/client.conf $HOME/.config/pulse/client.conf
	ln -s $HOME/git/configurations-and-scripts/linux/config/pulse/default.pa $HOME/.config/pulse/default.pa
	ln -s $HOME/git/configurations-and-scripts/linux/config/rncbc.org/QjackCtl.conf $HOME/.config/rncbc.org/QjackCtl.conf

}

function pass_init() {
	echo -e "\n * initialize password store. Be sure to have both the GPG key of thetruephil@googlemail.com and the SSH key for Gitlab registered.\n"

	git clone git@gitlab.com:theGreatWhiteShark/orga $HOME/git/orga || exit 1
	rm -rf $HOME/.password-store || exit 1
	ln -s $HOME/git/orga/.password-store $HOME/.password-store || exit 1

	pass init AFC1393E3E68B9300862D32D54A7A708A136FE39 || exit 1
}

function emacs_install() {
	echo -e "\n * install emacs...\n"
	## Compile the most recent Emacs version
	sudo apt -y install libasound2-dev libgtk-3-dev libxpm-dev libgnutls28-dev libtiff5-dev libgif-dev libxml2-dev libotf-dev libgpm-dev libncurses5-dev libjansson-dev liblcms2-dev texinfo

	git clone https://github.com/emacs-mirror/emacs.git $HOME/git/emacs
	cd $HOME/git/emacs/
	git checkout emacs-29.1.90
	./autogen.sh
	./configure
	make
	sudo make install
}

function general_install() {
	echo -e "\n * general installation...\n"
	
	## Install helpful packages
	sudo apt -y install apt-file at imagemagick pandoc scrot xinput xbacklight brightnessctl zsh \
			meld thunderbird strawberry terminator pasystray pavucontrol ispell ingerman  \
			wngerman aspell-de htop nextcloud-desktop nemo nemo-nextcloud i3-wm i3blocks  \
			i3lock i3status borgbackup qasmixer qasconfig r-base pmount xcompmgr adb vlc  \
			global info liblo-tools autoconf make gcc g++ pkg-config ecasound blueman git \
			libecasoundc-dev libcsound64-dev csound csound-utils csound-data ambdec curl  \
			pavumeter paprefs pulseaudio-module-jack synapse pass pm-utils redshift       \
			silversearcher-ag fd-find flatpak chromium openvpn rfkill
	sudo apt-file update
}

function audio_install() {
	echo -e "\n * installing audio packages...\n"
	
	## Install LADSPA plugins
	sudo apt -y install amb-plugins autotalent blepvco blop bs2b-ladspa \
		calf-plugins cmt csladspa drumgizmo drumkv1-lv2 fil-plugins     \
		guitarix-ladspa guitarix-lv2 invada-studio-plugins-ladspa       \
		invada-studio-plugins-lv2 ir.lv2 jalv ladspalist lv2-dev        \
		mcp-plugins omins pd-plugin rev-plugins rubberband-ladspa       \
		ste-plugins swh-plugins swh-lv2 tap-plugins vco-plugins         \
		wah-plugins zam-plugins php extra-cmake-modules || exit 1
	
	## compile and install lsp plugins
	sudo apt install -y libfltk1.3-dev libmxml-dev libfftw3-dev || exit 1
	git clone https://github.com/sadko4u/lsp-plugins $HOME/git/lsp-plugins || exit 1
	cd $HOME/git/lsp-plugins || exit 1
	git checkout 1.2.14 || exit 1
	make config FEATURES=’lv2 vst2 doc’ || exit 1
	make fetch || exit 1
	make -j4 || exit 1
	sudo make install || exit 1

	## compile and install Yoshimi
	git clone https://github.com/Yoshimi/yoshimi $HOME/git/yoshimi || exit 1
	cd $HOME/git/yoshimi || exit 1
	git checkout 2.3.1.3 || exit 1
	cd src || exit 1
	cmake . || exit 1
	make -j4 || exit 1
	sudo make install || exit 1

	## install Muse4
	git clone https://github.com/muse-sequencer/muse $HOME/git/muse || exit 1
	cd $HOME/git/muse/src || exit 1
	git checkout 4.2.1 || exit 1
	./compile_muse.sh || exit 1
	cd build || exit 1
	sudo make install || exit 1

}

function hydrogen_install() {
	echo -e "\n * install everything required to compile hydrogen...\n"
	## Compile and install hydrogen
	sudo apt -y install libqt5xmlpatterns5-dev libarchive-dev libsndfile1-dev \
			libasound2-dev liblo-dev libpulse-dev libcppunit-dev      \
			liblrdf0-dev librubberband-dev qtcreator xmlto docbook    \
			libjack-jackd2-dev ccache cmake libtar-dev doxygen        \
			qttools5-dev-tools qtbase5-dev-tools qttools5-dev         \
			qtbase5-dev libqt5svg5-dev
	git clone https://github.com/hydrogen-music/hydrogen.git $HOME/git/hydrogen
	cd $HOME/git/hydrogen
	./build.sh mm
	cd build
	sudo make install
}

function jack2_install() {
	echo -e "\n * install JACK2...\n"
	
	## Compile and install JACK2. (It has to be configured to NOT use
	## systemd)
	sudo apt -y install libeigen3-dev libopus-dev opus-tools  \
		libsamplerate0-dev libdb-dev
	git clone https://github.com/jackaudio/jack2.git $HOME/git/jack2
	cd $HOME/git/jack2
	git checkout v1.9.22
	./waf configure --systemd=no --dbus --enable-pkg-config-dbus-service-dir
	./waf build
	sudo ./waf install

	## Compile and install QJackCtl
	git clone https://github.com/rncbc/qjackctl $HOME/git/qjackctl
	cd $HOME/git/qjackctl/
	git checkout qjackctl_0_9_12
	cmake -DCONFIG_JACK_VERSION=yes -B build
	cmake --build build --parallel 4
	sudo cmake --install build
}

echo -e "Installation script written for Devuan Chimaera (last updated 2022.05.18)\n"

read -p "Installing audio libraries (apart from hydrogen) as well? [y/n] " AUDIO_REQUESTED

paths_and_folders
general_install
pass_init
emacs_install
hydrogen_install
jack2_install

if [ "$AUDIO_REQUESTED" == "y" ]; then
	audio_install
fi

## Final update
sudo apt update
sudo apt -y upgrade
sudo apt-get autoremove
sudo apt-file update
