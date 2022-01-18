#!/usr/bin/env bash
# From https://www.matoski.com/article/wifi-ethernet-autoswitch/

name_tag="wifi-wired-exclusive"
syslog_tag="$name_tag"
skip_filename="/etc/NetworkManager/.$name_tag"

if [ -f "$skip_filename" ]; then
  exit 0
fi

interface="$1"
iface_mode="$2"
iface_type=$(nmcli dev | grep "^$interface" | tr -s ' ' | cut -d' ' -f2)
iface_state=$(nmcli dev | grep "^$interface" | tr -s ' ' | cut -d' ' -f3)

# Check, if an ethernet is left
# This is needed if the ethernet-interface is getting unplugged
connected_ethernets_left=$(nmcli dev | grep "\sethernet\s" | tr -s ' ' | cut -d' ' -f3 | grep "connected")

# Check, if we try to switch off wifi
# If we are on wifi and want to switch it off, we should not consider, if
# no ethernet is left, because then we just switch it on again.
if [ "$iface_type" = "wifi" ] && [ ! $connected_ethernet_left = 0 ]; then
  switch_without_ethernet = 1
fi

logger -i -t "$syslog_tag" "Interface: $interface = $iface_state ($iface_type) is $iface_mode"

enable_wifi() {
   logger -i -t "$syslog_tag" "Interface $interface ($iface_type) is down, enabling wifi ..."
   nmcli radio wifi on
}

disable_wifi() {
   logger -i -t "$syslog_tag" "Disabling wifi, ethernet connection detected."
   nmcli radio wifi off
}

if [ "$iface_type" = "ethernet" ] || [ "$switch_without_ethernet" ] && [ "$iface_mode" = "down" ]; then
  enable_wifi
elif [ "$iface_type" = "ethernet" ] && [ "$iface_mode" = "up"  ] && [ "$iface_state" = "connected" ]; then
  disable_wifi
fi

