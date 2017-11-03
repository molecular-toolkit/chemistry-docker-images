#!/bin/bash

if [ -z $1 ]; then
   echo "usage: pull.sh [tag]"
   exit 1
else
   tag=$1
fi

imgs=$(cat makefiles/DockerMake.yml | shyaml get-values _ALL_)

function echocmd() {
   echo "> $@"
   $@
}

function run-pull(){
    # pull an image. If successful, retags the image with the "cache" tag
    img=$1;
    tag=$2;

    echocmd docker pull chemdocker/${img}:${tag} | \
       tee -a pull.log | awk '/Pull/ && /Already exists/';

    success=${PIPESTATUS[0]}
    if [ "$success" -ne 0 ]; then
       return $success;
    else
       docker tag chemdocker/${img}:${tag} chemdocker/${img}:cache
    fi
}


for img in ${imgs}; do
   run-pull $img $tag || run-pull $img master || \
   echo " --> Failed to pull cache for ${img}"
   echo
done
