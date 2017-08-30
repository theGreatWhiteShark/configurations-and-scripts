As for the latest Raspbian image *2017-08-16-raspbian-stretch* I tried my WIFI dongle was not recognized anymore out of the box. In addition the network managing service associated with the tray icon does not work at all. So I had configure things by hand.

# Obtaining the wireless interface

The following command gives a list of all wireless interfaces.
```{bash}
iwconfig
```
If you don't see any interface at all, remove your dongle, plug it in again, and run
```{bash}
dmesg | tail -30
```
This reports all the actions your system took in order to recognize and associate your WIFI dongle. It also tells you about which driver was used and whether an error occurred. 

Now note down the name of your wireless interface and let's set up things using the command line. (For some reason my *wlan0* is being renamed to *wlxf81a671a0070*. Quite weird, but you have to stick with this name in case your WIFI got renamed too.)

# Configuring the network access
First we will set up the network access via the **wpa** suite. We will tell it which network to use via a SSID and which password is associated with it. So it basically works like one of those graphical interfaces you use when selecting your network.

```{bash}
# temporally get superuser rights
sudo -i
wpa_passphrase [Network SSID] [Network password] >> /etc/wpa_supplicant/wpa_supplicant.conf
# switch back to your user account
exit
```

If you are not sure about the SSID of your network or if the dongle actually sees any of the available ones, run this command.

```{bash}
sudo iwlist [Interface name] scan
```
Be sure to use *sudo* or you won't find anything!

# Configuring the interface
To configure your network, copy the [interfaces](interfaces) file into */etc/network/interfaces* and exchange my interface name for the one obtained in the previous step.

In my configuration I used a static setting. This way my Raspberry also obtains the same IP address. (Very convenient when you are using e.g. Clementine with a remote control via your smartphone).
If you want a dynamic setting instead (your Raspberry will obtain different IPs), replace lines 11-14 by this one instead

```
iface [Interface name] inet dhcp
```

To start up your newly configured interface, run
```{bash}
sudo ifup [Interface name]
```
