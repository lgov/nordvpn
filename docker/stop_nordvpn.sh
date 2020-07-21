#!/usr/bin/env bash

pushd docker
pushd nordvpn
MY_DOCKER_HOST=`ip -f inet addr show docker0 | awk '/inet/ {print $2}' | cut -d/ -f1` \
  docker-compose stop
popd
popd
