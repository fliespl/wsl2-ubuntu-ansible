#!/bin/bash

sudo apt update
sudo apt upgrade --yes
sudo apt install ansible git --yes
ansible-galaxy install -r requirements.yml
