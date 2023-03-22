#!/bin/bash

# Install mod_security and its dependencies
sudo apt-get update
sudo apt-get install -y libapache2-mod-security2

# Enable mod_security
sudo a2enmod security2

# Create a new security configuration file
sudo touch /etc/modsecurity/modsecurity.conf

# Add some basic configuration to the new file
echo "SecRuleEngine On" | sudo tee -a /etc/modsecurity/modsecurity.conf
echo "SecRequestBodyAccess On" | sudo tee -a /etc/modsecurity/modsecurity.conf

# Create a new rules file for mod_security
sudo touch /etc/modsecurity/modsecurity_customrules.conf

# Add some basic rules to the new file
echo "# Block common attacks" | sudo tee -a /etc/modsecurity/modsecurity_customrules.conf
echo "SecRule ARGS \"@rx (?:eval\(|base64_decode\(|gzip\(base64_decode\(|chr\(\d{1,3}\)\+chr\(\d{1,3}\)|" \ | sudo tee -a /etc/modsecurity/modsecurity_customrules.conf
echo "    \"id:1,phase:2,deny,status:400,msg:'Command Injection Attempt'" | sudo tee -a /etc/modsecurity/modsecurity_customrules.conf

# Restart Apache to apply changes
sudo systemctl restart apache2
