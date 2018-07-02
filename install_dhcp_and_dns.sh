#!/bin/sh

# Configure the machine network settings until reboot (assumes that no DHCP is available)
sudo ifconfig eth0 192.168.1.254/24
sudo route add default gateway 192.168.1.1
sudo su -c 'echo "nameserver 1.1.1.1" >> /etc/resolv.conf'

# Install the necessary packages to automatically configure the machine network settings on boot
sudo apt-get update
sudo apt-get -y install ifupdown resolvconf
sudo su -c "cat etc-network-interfaces >> /etc/network/interfaces"

# Install the DNS and DHCP servers
sudo apt-get install -y bind9 isc-dhcp-server

sudo perl -i -p -e "s|INTERFACESv4=\"\"|INTERFACESv4=\"eth0\"|" /etc/default/isc-dhcp-server
sudo cp -f dhcp/dhcpd.conf /etc/dhcp/
sudo cp -f dhcp/isc-dhcp-server /etc/network/if-up.d/

sudo /usr/sbin/rndc-confgen -a
sudo cp -f dns/named.conf.options /etc/bind/
sudo cp -f dns/named.conf.local /etc/bind/
sudo cp -f dns/db.home /etc/bind/
sudo chown bind:bind /etc/bind/db.home
sudo cp -f dns/db.1.168.192.rev /etc/bind/
sudo chown bind:bind /etc/bind/db.1.168.192.rev
sudo chown bind:bind /etc/bind

rndc_key=$(sudo cat /etc/bind/rndc.key)
sudo perl -i -p -e "s|key rndc-key \{\}|$rndc_key|" /etc/dhcp/dhcpd.conf

# Update firewall rules (assumes that UFW is installed)
sudo ufw allow bind9
sudo ufw allow 67/udp

sudo systemctl start bind9.service
sudo systemctl enable bind9.service
sudo systemctl start isc-dhcp-server.service
sudo systemctl enable isc-dhcp-server.service
echo ""
echo "If isc-dhcp-server is not running try to restart the service using 'sudo systemctl restart isc-dhcp-server.service'."
echo ""
sudo systemctl status isc-dhcp-server.service
