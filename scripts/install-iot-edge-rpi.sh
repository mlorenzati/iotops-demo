#!/bin/bash

# Download the Microsoft configuration package
curl https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb > ./packages-microsoft-prod.deb

# Install configuration package
sudo apt install ./packages-microsoft-prod.deb

# Eliminate downloaded packages
rm packages-microsoft-prod.deb

# Update and install the Azure IoT Edge and Defender IoT Micro Agent Edge
sudo apt-get update
sudo apt-get install -y moby-engine aziot-edge #defender-iot-micro-agent-edge