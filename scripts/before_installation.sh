#!/bin/bash
sudo apt update -y
sudo apt-get install python3-pip -y
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io -y 
sudo apt install docker-compose -y
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y