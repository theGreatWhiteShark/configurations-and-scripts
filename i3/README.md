# Configuration files and scripts for the [i3](https://i3wm.org/) window manager

In this folder I provide two different versions of the overall i3 configuration file *config* and the i3 status bar configuration file *.i3status.conf*. They are named after the two laptops I use most frequently (the differences are only minor ones). 

To use those files, create a symbolic link to them in your home.

```
# In the repository's home
mkdir ~/.i3
ln -s i3/config-abyzou ~/.i3/config
ln -s i3/.i3status.conf-abyzou ~/.i3status.conf
```

## Scripts

In addition, I provide some bash scripts easing the handling of i3

#### i3lock_screenshot.sh

An awesome idea for a lock screen I picked up in a StackOverflow answer a while ago. The script will take a screenshot of the current active workspace, blurs the image using the **imagemagick** toolkit and uses the blurred one as the locking screen.

#### toggle_touchpad.sh

Switching the touchpad of the laptop on and off. Since it's quite annoying to touch it every second minute while programming
