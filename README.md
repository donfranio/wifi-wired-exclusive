# wifi-wired-exclusive

This Script configures NetworkManager to switch off Wifi, when an ethernet
interface gets connected and switches it on on disconnect again.

It is useful to avoid duplicate connections confusing some applications.

## Disclaimer

It is not from me but copied from the internet, see:
https://www.matoski.com/article/wifi-ethernet-autoswitch/ as of Dec. 09th 2021.

The original is from Dec 20th 2015.
Thanks btw.

## Installation

Copy it to `/etc/NetworkManager/dispatcher.d/70-wired-wireless-exclusive.sh` and
make it executeable.
