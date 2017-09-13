
### This will build an AP with subnet range 10.10.1.64/24 10.10.1.64 - 10.10.1.127
### AP will be SSID:   Cindy_AP
### AP passwd will be: raspberry
###
### 

apt-get -y install hostapd dnsmasq
cp ./etc/dhcpcd.conf          /etc/dhcpcd.conf
cp ./etc/network/interfaces   /etc/network/interfaces
cp ./etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf
cp ./etc/default/hostapd      /etc/default/hostapd
cp ./etc/dnsmasq.conf         /etc/dnsmasq.conf


service hostapd start 
service dnsmasq start 

ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

shutdown -r now 
