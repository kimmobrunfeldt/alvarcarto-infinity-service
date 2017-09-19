#!/bin/bash

set -e
set -x

cd server

wget https://github.com/mholt/caddy/releases/download/v0.10.9/caddy_v0.10.9_linux_amd64.tar.gz
mkdir caddy_v0.10.9_linux_amd64
cd caddy_v0.10.9_linux_amd64
tar zxvvf ../caddy_v0.10.9_linux_amd64.tar.gz

# Following these instructions https://github.com/mholt/caddy/tree/master/dist/init/linux-systemd

sudo cp caddy /usr/local/bin
sudo chown root:root /usr/local/bin/caddy
sudo chmod 755 /usr/local/bin/caddy

# Give the caddy binary the ability to bind to privileged ports (e.g. 80, 443) as a non-root user:
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy

# Set up the user, group, and directories that will be needed:

# (skipped www-data and user creation, ubuntu has those by default)

sudo mkdir -p /etc/caddy
sudo chown root:www-data /etc/caddy
sudo mkdir -p /etc/ssl/caddy
sudo chown -R www-data:root /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy

# Setup config file
sudo cp ../Caddyfile /etc/caddy/
sudo chown www-data:www-data /etc/caddy/Caddyfile
sudo chmod 444 /etc/caddy/Caddyfile

sudo cp init/linux-systemd/caddy.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/caddy.service
sudo chmod 644 /etc/systemd/system/caddy.service
sudo systemctl daemon-reload
sudo systemctl start caddy.service

# Enable automatic on boot
sudo systemctl enable caddy.service

# Add access.log if it doesn't yet exist
sudo touch /var/log/access.log
sudo chown www-data:www-data /var/log/access.log

# Debugging, see the last paragraphs of installation instructions:
# https://github.com/mholt/caddy/tree/master/dist/init/linux-systemd

echo -e "\n\n\n---------------------------------\n"
echo -e "Debugging, see the last paragraphs of installation instructions:"
echo -e "https://github.com/mholt/caddy/tree/master/dist/init/linux-systemd"
echo -e "\n---------------------------------\n\n\n"
