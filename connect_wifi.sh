#!/bin/bash

# specify the Wi-Fi SSID and password
ssid="Your_SSID"
password="Your_Password"

# connect to the Wi-Fi network
nmcli device wifi connect $ssid password $password

