Various helpful configuration files.

## Devuan (or change-logs compared to the Ubuntu version)

When was switching from Ubuntu to [Devuan](http://devuan.org/) Linux I found *dmenu*, bound to *$mod+d* in i3 and the default application selector, not working anymore. Instead I switched to [kupfer](https://kupferlauncher.github.io/) which is not just running like a charm but also way more powerful. Check it out!

Prior I was using the *mate-terminal* terminal emulator. But since it's using [gsettings](https://wiki.mate-desktop.org/docs:gsettings) as an interface and stores the user profiles in the binary *~/.config/dconf/user* file, it is quite a pain in the ass to migrate it to a newly installed system. Therefore I decided to use **terminator** instead.


## .xmodmap

This one defines which keystroke is related to which keystroke is related to which character/symbol.

Since I almost never use the tabs lock and on the other hand it is quite annoying when you hit it by mistake, I just disabled this button for good. 

## .xinitrc

Init file for X11. This little script will be execute right after the login-manager (I can highly recommend [SLiM](https://wiki.archlinux.org/index.php/SLiM)) validated your password. It will start up the i3 window manager using `exec i3`. If not present, the login-manager would just use its default (e.g. the last chosen option). In addition it turns off the blank screen occurring after some minutes. Especially in i3 I found this to be quite annoying.

## .xprofile

I want to be my second screen to be always left of my laptop.
