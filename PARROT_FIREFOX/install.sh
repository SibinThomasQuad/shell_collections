#!/bin/bash

# Create directory for APT repository keys if it doesn't exist
sudo install -d -m 0755 /etc/apt/keyrings

# Import the Mozilla APT repository signing key
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

# If wget is not installed, you can install it
# sudo apt-get install wget

# Verify the fingerprint
FINGERPRINT="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); print "\n"$0"\n"}' | grep -q "$FINGERPRINT" || { echo "Invalid key fingerprint"; exit 1; }

# Add the Mozilla APT repository to sources list
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

# Configure APT to prioritize packages from the Mozilla repository
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla > /dev/null

# Update package list and install Firefox
sudo apt-get update && sudo apt-get install firefox
