#!/bin/bash

if [ -z $1 ]; then
   echo "usage: push.sh [tag]"
   exit 1
else
   tag=$1
fi

docker-make -f makefiles/DockerMake.yml \
            --repo docker.io/chemdocker \
            --tag ${tag}                \
            --all                       \
            --cache-tag build           \
            --push --user ${DOCKERHUB_USER} --token ${DOCKERHUB_PASSWORD}
