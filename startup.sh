#!/bin/bash

# Log the start of the script
echo "Starting system update and upgrade at $(date)" >> /var/log/startup_script.log

# Update and upgrade silently
sudo apt-get update -y >> /var/log/startup_script.log 2>&1
sudo apt-get upgrade -y >> /var/log/startup_script.log 2>&1

# Clean up unnecessary packages
sudo apt-get autoremove -y >> /var/log/startup_script.log 2>&1
sudo apt-get autoclean -y >> /var/log/startup_script.log 2>&1

# Log the start of Squid installation
echo "Installing Squid proxy server at $(date)" >> /var/log/startup_script.log

# Install Squid proxy server
sudo apt-get install -y squid >> /var/log/startup_script.log 2>&1

# Configure Squid for a basic proxy and hide client information
sudo bash -c 'cat > /etc/squid/squid.conf <<EOL

# Squid Proxy Configuration Allow ALL

# Define the port on which Squid listens (default: 3128)
http_port 3128

# Cache Directory Configuration
cache_dir ufs /var/spool/squid 100 16 256
cache_mem 256 MB

# Allow all IP addresses to access the proxy
acl all_ips src 0.0.0.0/0
http_access allow all_ips

# Deny access to all other requests (if needed)
# http_access deny all

# Disable caching of certain types of content (optional)
acl no_cache dstdomain .google.com .youtube.com
cache deny no_cache

# Logging
access_log /var/log/squid/access.log
cache_log /var/log/squid/cache.log

# DNS Resolution
dns_nameservers 8.8.8.8 8.8.4.4

EOL'

# Restart Squid to apply changes
echo "Restarting Squid proxy server at $(date)" >> /var/log/startup_script.log
sudo systemctl restart squid >> /var/log/startup_script.log 2>&1

# Log the completion of the script
echo "Startup script completed at $(date)" >> /var/log/startup_script.log
