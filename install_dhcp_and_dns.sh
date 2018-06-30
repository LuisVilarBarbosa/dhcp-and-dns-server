#!/bin/sh

sudo ifconfig eth0 192.168.1.254/24
sudo route add default gateway 192.168.1.1
sudo su -c 'echo "nameserver 1.1.1.1" >> /etc/resolv.conf'

sudo apt-get update
sudo apt-get install -y bind9 isc-dhcp-server

sudo perl -i -p -e "s|INTERFACES=\"\"|INTERFACES=\"eth0\"|" /etc/default/isc-dhcp-server
sudo cp -f dhcp/dhcpd.conf /etc/dhcp/
sudo cp -f dhcp/dhcpcd.conf /etc/
sudo cp -f dhcp/isc-dhcp-server /etc/network/if-up.d/

sudo /usr/sbin/rndc-confgen -a
sudo cp -f dns/named.conf.options /etc/bind/
sudo cp -f dns/named.conf.local /etc/bind/
sudo cp -f dns/db.home /etc/bind/
sudo cp -f dns/db.1.168.192.rev /etc/bind/

rndc_key=$(sudo cat /etc/bind/rndc.key)
sudo perl -i -p -e "s|key rndc-key \{\}|$rndc_key|" /etc/dhcp/dhcpd.conf

sudo ufw allow bind9
sudo ufw allow 67/udp

sudo systemctl enable bind9.service
sudo systemctl enable isc-dhcp-server.service
sudo reboot
