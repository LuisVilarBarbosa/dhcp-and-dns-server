# DHCP and DNS server

This repository contains the configuration of a DHCP server associated to a DNS server which is updated by the DHCP server whenever a lease is made.

The entry point to install the servers is "install_dhcp_and_dns.sh".

This configuration is useful to override the DNS servers provided by network operators routers, which configuration is limited, and useful when we need to install the servers on hardware like a Raspberry Pi that does not support software like pfSense.

In terms of best practices, a DNS server should have the first address of the network and the router should have the last address, but, in this case, the router has the first address and the DHCP and DNS servers are on another machine that has the last address, substituting the DHCP and DNS services provided by the router.

Be free to change this configuration to suit your needs and give suggestions or indicate issues.

To verify if everything is working, access /var/log/syslog and look at the messages written by "named" and "dhcpd".

This configuration has been tested with success on Debian Stretch 9.4.0 and Raspbian Stretch 9.4. The updates sent by the DHCP server to the DNS server did not perform correctly on Ubuntu Server 16.04 and Ubuntu Server 18.04 due to permissions problems that are not related to AppArmor and that did not happen on the distributions previously indicated.

This configuration is originally based on:
- https://www.tecmint.com/install-dhcp-server-in-ubuntu-debian/
- https://blog.bigdinosaur.org/running-bind9-and-isc-dhcp/
- https://www.itzgeek.com/how-tos/linux/debian/how-to-configure-static-ip-address-in-ubuntu-debian.html
