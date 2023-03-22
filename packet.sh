#!/bin/bash

# specify the network interface to capture packets from
interface=wlp0s20f3

# capture packets and display them on the terminal
tcpdump -i $interface

