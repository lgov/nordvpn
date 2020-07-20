#!/bin/sh

docker build --network=host -t nordvpn -f ./docker/Dockerfile .

