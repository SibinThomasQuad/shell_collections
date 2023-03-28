#!/bin/bash

echo "Enter IP address to scan:"
read IP

for port in $(seq 1 65535); do
    nc -zvw 1 $IP $port >/dev/null 2>&1 && echo "Port $port is open"
done
