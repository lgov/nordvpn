#!/usr/bin/env bash

# Prerequisites:
# install docker compose
# https://docs.docker.com/compose/install/
# add aws creds for [image-ecr] in ~/.aws/credentials

# Make sure the ubuntu user's crontab has this line:
# @reboot cd /home/ubuntu/dev/nordvpn && docker/run_nordvon.sh


# Wait for the docker network to be online
while ! ip -f inet addr show docker0; do
  sleep 5
done

pushd docker
echo "Sending docker-compose output to ~/docker_compose.log"

echo "---------------------- STARTING ------------------------------" >> ~/docker_compose.log
currentDate=`date`
echo "Current time: $currentDate" >> ~/docker_compose.log

pushd nordvpn
MY_DOCKER_HOST=`ip -f inet addr show docker0 | awk '/inet/ {print $2}' | cut -d/ -f1` docker stack deploy --compose-file docker-compose.yml nordvpn >> ~/docker_compose.log 2>&1
popd
echo "-----------------------FINISHED ------------------------------" >> ~/docker_compose.log

popd
