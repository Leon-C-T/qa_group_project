#!/bin/bash
sudo usermod -aG docker $USER
source ~/.bashrc
docker login --username=$DOCKER_USER --password=$DOCKER_PASS
docker build -t thenu97/frontend /var/lib/jenkins/workspace/latte/spring-petclinic-ang/.
docker push thenu97/frontend
sleep 20
docker build -t thenu97/backendpre /var/lib/jenkins/workspace/latte/spring-petclinic-res/.
docker push thenu97/backendpre