#!/bin/bash

echo "Server Performance Analysis Report"
echo "----------------------------------"
echo ""

echo "CPU Usage"
echo "========="
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'

echo ""
echo "Memory Usage"
echo "============"
free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'

echo ""
echo "Disk Usage"
echo "=========="
df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'

echo ""
echo "Network Usage"
echo "============="
netstat -ant | awk '{print $6}' | sort | uniq -c | sort -n

echo ""
echo "Processes"
echo "========="
ps auxf --width=200
