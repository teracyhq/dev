#! /bin/bash
source ~/.profile

echo "export DOCKER_USERNAME_$1=$2" >> ~/.profile

echo "export DOCKER_PASSWORD_$1=$3" >> ~/.profile

echo $DOCKER_USERNAME_0
echo $DOCKER_USERNAME_1