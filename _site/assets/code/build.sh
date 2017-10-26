#!/bin/bash
clear

# Ensure before running that the environment variables
# make sense on your operating system

sudo docker build -t doshico_image \
--build-arg username=$USER \
--build-arg uid=$UID \
--build-arg gid=$GROUPS \
--build-arg display=':0' .

