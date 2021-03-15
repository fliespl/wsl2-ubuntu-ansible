#!/bin/bash

sudo apt-get -qq update && sudo apt install gnupg2 --yes

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

if [ "$(awk -F= '/^ID=/{print $2}' /etc/os-release)" = "debian" ]; then
  # for debian we use trusty
  echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/ansible.list
else
  echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ansible.list
fi


sudo apt-get -qq update && sudo apt-get -qq upgrade --yes && sudo apt-get -qq install ansible git --yes

ansible-playbook initial.yml