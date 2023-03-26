#!/bin/bash

# Create a Systemd unit file for your Python script
cat > /etc/systemd/system/my_python_service.service << EOF
[Unit]
Description=My Python Service
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=<path-to-python-script>
ExecStart=/usr/bin/python3 <path-to-python-script>/<script-name>.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload Systemd to pick up the new unit file
systemctl daemon-reload

# Start the service
systemctl start my_python_service

# Enable the service to start on boot
systemctl enable my_python_service
