
### This will build an AP with subnet range 10.10.1.64/24 10.10.1.64 - 10.10.1.127
### AP will be SSID:   demo-ap
### AP passwd will be: raspberry
###
### 

apt-get -y update
apt-get -y install hostapd dnsmasq
cp ./etc/dhcpcd.conf          /etc/dhcpcd.conf
cp ./etc/network/interfaces   /etc/network/interfaces
cp ./etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf
cp ./etc/default/hostapd      /etc/default/hostapd
cp ./etc/dnsmasq.conf         /etc/dnsmasq.conf
cp ./etc/sysctl.conf           /etc/sysctl.conf
cp ./etc/rc.local             /etc/rc.local

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o wlan2 -j MASQUERADE  
iptables -A FORWARD -i wlan2 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
iptables -A FORWARD -i wlan0 -o wlan2 -j ACCEPT
sh -c "iptables-save > /etc/iptables.ipv4.nat"


service hostapd start 
service dnsmasq start 

ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

shutdown -r now 
