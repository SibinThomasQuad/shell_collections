#!/bin/bash

# Install the MongoDB repository
echo "[mongodb-org-4.4]" | sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo
echo "name=MongoDB Repository" | sudo tee -a /etc/yum.repos.d/mongodb-org-4.4.repo
echo "baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/" | sudo tee -a /etc/yum.repos.d/mongodb-org-4.4.repo
echo "gpgcheck=1" | sudo tee -a /etc/yum.repos.d/mongodb-org-4.4.repo
echo "enabled=1" | sudo tee -a /etc/yum.repos.d/mongodb-org-4.4.repo
echo "gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc" | sudo tee -a /etc/yum.repos.d/mongodb-org-4.4.repo

# Install MongoDB
sudo yum install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod

# Enable MongoDB to start at boot
sudo systemctl enable mongod

# Secure MongoDB by creating a user with a strong password
mongo <<EOF
use admin
db.createUser({
    user: "admin",
    pwd: "strong_password",
    roles: [ { role: "root", db: "admin" } ]
})
EOF

# Configure MongoDB to only listen on the local interface
sudo sed -i "s/bindIp: .*/bindIp: 127.0.0.1/" /etc/mongod.conf

# Set MongoDB to use only TLS encryption
sudo sed -i "s/#security:/security:\n  clusterAuthMode: x509\n  tls:\n    mode: requireTLS\n    certificateKeyFile: \/path\/to\/server.pem\n    CAFile: \/path\/to\/ca.pem\n/" /etc/mongod.conf

# Restart MongoDB to apply the changes
sudo systemctl restart mongod
