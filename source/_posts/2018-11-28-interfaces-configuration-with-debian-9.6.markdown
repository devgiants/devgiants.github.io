---
layout: post
title:  "Interfaces configuration with Debian 9.6"
date:   2018-11-28 17:26:00 +0100
tags:
    - Ubuntu
    - system
    - Netplan
    - network
    - router
excerpt: "This post explains how to persist interfaces attributions and tuning them for your needs"
    
---

## Context
As I stated [in my previous post](https://devgiants.fr/blog/2018/11/27/netplan-handling-network/), I changed from ubuntu Server 18.10 to Debian 9.6 for the system I'm building (a router/firewall and application server for home automation). Below ismytraces for interface configuration.
 
## Renaming
As I also stated [in my previous post](https://devgiants.fr/blog/2018/11/27/netplan-handling-network/), I need renaming for 2 reasons :
- 5 interfaces (4 LAN + 1 Wifi) : need to know which one I'm using, with __a meaningful way according to my system__.
- To be sure to have __interfaces always linked to the same adapter__ (by using MAC address matching).

### For the session

Following code will effectively rename your interface __until next reboot__.  

```
ip link set eth0 down
ip link set eth0 name your_new_name
ip link set your_new_name up
```

Quite useless on a production usage.

### Definitely

The persistent solution goes through 2 steps :

#### 70-persistent-net.rules
This is a file (normally) generated by `/lib/udev/write_net_rules`, a command-line tool from [with udev system](https://www.debian.org/doc/manuals/debian-reference/ch03.en.html#_the_udev_system). I said normally becasue on my fresh Debian install, it's not here. I created one from examples found on the web :

```
/etc/udev/rules.d/70-persistent-net.rules
# This file was automatically generated by the /lib/udev/write_net_rules
# program, run by the persistent-net-generator.rules rules file.
#
# You can modify it, as long as you keep each rule on a single
# line, and change only the value of the NAME= key.

SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:11:22:33:44:55", ATTR{type}=="1", NAME="wan"
```
So just replace your MAC address above, and the mathcing interface will take the given name.

#### /etc/network/interfaces

Next step is to adjust interface declaration in `/etc/network/interfaces`. For my case, so far it is : 

```
# The primary network interface
allow-hotplug wan
iface wan inet dhcp
```

Now, my `wan` interface, which will be linked to my 4G modem, will be the wan entry for all the system. The 4G router will allow address with DHCP, according to configuration done above.

Next steps to come :
- Create LAN interface with another available adapter
- Configure Wifi interface as an Access Point
- Setup a DHCP server for both
- Traffic forwarding from LAN/Wifi to WAN
- Setup a DNS server
- Firewall both ways

Stay tuned !
