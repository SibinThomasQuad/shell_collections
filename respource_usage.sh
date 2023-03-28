#!/bin/bash

echo "---------------Top 10 processes by CPU usage-------------------------"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 11

echo "---------------Top 10 processes by memory usage----------------------"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 11

echo "---------------------------------------------------------------------"
