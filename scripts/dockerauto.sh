#!/bin/bash
sudo usermod -aG docker $USER
source ~/.bashrc
docker login --username=$DOCKER_USER --password=$DOCKER_PASS
docker build -t thenu97/frontend /var/lib/jenkins/workspace/latte/spring-petclinic-angular/.
docker push thenu97/frontend