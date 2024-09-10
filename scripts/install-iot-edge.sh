#!/bin/bash

# Download the Microsoft configuration package
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# Install configuration package
sudo dpkg -i packages-microsoft-prod.deb

# Eliminate downloaded packages
rm packages-microsoft-prod.deb

# Update and install the Azure IoT Edge and Defender IoT Micro Agent Edge
sudo apt-get update
sudo apt-get install aziot-edge defender-iot-micro-agent-edge