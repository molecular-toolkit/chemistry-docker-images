#!/bin/bash

if [ -z $1 ]; then
   echo "usage: pull.sh [tag]"
   exit 1
else
   tag=$1
fi

imgs=$(cat makefiles/DockerMake.yml | shyaml get-values _ALL_)

for img in ${imgs}; do
   docker pull chemdocker/${img}:${tag} || \
   docker pull chemdocker/${img}:master || \
   echo "Failed to pull cache for ${img}"
done
