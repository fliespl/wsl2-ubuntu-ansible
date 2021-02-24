#!/bin/bash

sudo apt update
sudo apt upgrade --yes
sudo apt install ansible git --yes
ansible-galaxy install -r requirements.yml
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /tmp/microsoft.deb
dpkg -i /tmp/microsoft.deb
sudo apt update
sudo apt install daemonize dotnet-runtime-5.0 systemd-container --yes
wget https://github.com/arkane-systems/genie/releases/download/v1.35/systemd-genie_1.35_amd64.deb -O /tmp/genie.deb
dpkg -i /tmp/genie.deb
sudo apt update
sed -i 's/systemd-timeout=180/systemd-timeout=10/g' /etc/genie.ini
genie -c bash
#ansible-playbook local.yml