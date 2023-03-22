#!/bin/bash

# specify the network interface to capture packets from
interface=wlp0s20f3

# capture HTTP traffic and display the URLs being visited
tcpdump -i $interface -A -s 0 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420' | grep -Ei '(GET|POST) /' | awk '{print $2}' | cut -d '?' -f 1

