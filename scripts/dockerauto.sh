#!/bin/bash
sudo usermod -aG docker $USER
source ~/.bashrc
docker login --username=$DOCKER_USER --password=$DOCKER_PASS
docker build -t thenu97/frontend /var/lib/jenkins/workspace/latte/spring-petclinic-angular-1/.
docker push thenu97/frontend
export url="$(curl https://ipinfo.io/ip)"