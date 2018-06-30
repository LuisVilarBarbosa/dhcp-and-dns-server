# DHCP and DNS server

This repository contains the configuration of a DHCP server associated to a DNS server which is updated by the DHCP server whenever a lease is made.

This configuration is useful to override the DNS servers provided by network operators routers, which configuration is limited, and useful when we need to install the servers on hardware like a Raspberry Pi that does not support software like pfSense.

In terms of best practices, a DNS server should have the first address of the network and the router should have the last address, but, in this case, the router has the first address and the DHCP and DNS servers are on another machine that has the last address, substituting the DHCP and DNS services provided by the router.

Be free to change this configuration to suit your needs.

This configuration is originally based on:
- https://www.tecmint.com/install-dhcp-server-in-ubuntu-debian/
- https://blog.bigdinosaur.org/running-bind9-and-isc-dhcp/
