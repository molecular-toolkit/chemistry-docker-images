#!/usr/bin/env bash

docker-make -f makefiles/DockerMake.yml --all             \
             --cache-repo chemdocker --cache-tag cache    \
             --tag build
