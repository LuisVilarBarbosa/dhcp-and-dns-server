#!/bin/sh

sudo apt-get update
sudo apt-get install -y bind9 isc-dhcp-server

sudo su -c 'sed -i "s|INTERFACES=\"\"|INTERFACES=\"eth0\"|g" /etc/default/isc-dhcp-server > /etc/default/isc-dhcp-server'
sudo cp -f dhcp/dhcpd.conf /etc/dhcp/
sudo cp -f dhcp/dhcpcd.conf /etc/

sudo /usr/sbin/rndc-confgen -a
sudo cp -f dns/named.conf.options /etc/bind/
sudo cp -f dns/named.conf.local /etc/bind/
sudo cp -f dns/db.home /etc/bind/
sudo cp -f dns/db.1.168.192.rev /etc/bind/

sudo su -c 'rndc_key=$(sudo cat /etc/bind/rndc.key) && sed "s|key rndc-key {}|$rndc_key|g" /etc/dhcp/dhcpd.conf > /etc/dhcp/dhcpd.conf'

sudo ufw allow bind9
sudo ufw allow 67/udp

sudo systemctl enable bind9.service
sudo systemctl enable isc-dhcp-server.service
sudo reboot
