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
    echocmd docker pull chemdocker/$1 | \
       tee -a pull.log | awk '/Pull/ && /Already exists/'
    return ${PIPESTATUS[0]}
}


for img in ${imgs}; do
   run-pull ${img}:${tag} || run-pull ${img}:master || \
   echo " --> Failed to pull cache for ${img}"
   echo
done
