# Configure Access Point #

This document goes over the process of setting up an access point.

### Display all interfaces

~~~
ifconfig -a
~~~

Note if ifconfig -a gives strange device names, run the following as root, this will fix udev rules:

~~~
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
~~~

#### Display all usb devices

~~~
lsusb
lsmod
iwconfig
~~~

### Install Access Point Drivers:

##### Standard Base-Lining of Raspberry OS Packages
~~~
sudo apt-get -y update
sudo apt-get -y dist-upgrade
~~~

##### Install all the required software:

~~~
sudo apt-get install dnsmasq hostapd
~~~

##### Stop Services

~~~
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd
~~~

Edit /etc/network/interface

~~~
auto lo
iface lo inet loopback

auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
        address   10.10.1.1
        network   10.10.1.0
        broadcast 10.10.1.255
        netmask   255.255.255.0

auto wlan1
allow-hotplug wlan1
iface wlan1 inet dhcp
   wpa-ssid "demo-ap"
   wpa-psk  "raspberry"
~~~

Edit /etc/dhcpcd.conf

~~~
denyinterfaces wlan0
~~~

Edit /etc/hostapd/hostapd.conf

~~~
interface=wlan0
driver=nl80211
ssid=demo-ap
hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_passphrase=raspberry
rsn_pairwise=CCMP
~~~

Edit /etc/dnsmasq.conf

~~~
interface=wlan0      # Use interface wlan0
listen-address=10.10.1.1 # Explicitly specify the address to listen on
bind-interfaces      # Bind to the interface to make sure we aren't sending things elsewhere
server=8.8.8.8       # Forward DNS requests to Google DNS
domain-needed        # Don't forward short names
bogus-priv           # Never forward addresses in the non-routed address spaces.
                     #
                     # Assign IP addresses between 172.24.1.50 and 172.24.1.150
                     # with a 12 hour lease time
dhcp-range=10.10.1.64,10.10.1.127,12h 
~~~
