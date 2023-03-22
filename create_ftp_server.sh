#!/bin/bash

echo "Creating a new FTP server..."
echo ""

# Install vsftpd
apt-get update
apt-get install vsftpd -y

# Configure vsftpd
cat << EOF > /etc/vsftpd.conf
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=Yes
EOF

# Restart vsftpd
systemctl restart vsftpd.service

echo "FTP server created successfully!"
