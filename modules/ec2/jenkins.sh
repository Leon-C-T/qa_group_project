#!/bin/bash
sudo apt update && sudo apt upgrade -y
#Install Java:
sudo apt install openjdk-8-jdk -y
#Add key for the Jenkins apt repository:
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
#Add Jenkins Apt Repo:
sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
#Install Jenkins
sudo apt-get install jenkins -y
#AWS-CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
sudo ./aws/install 
echo 'jenkins ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
sleep 30