docker-make -f makefiles/DockerMake.yml \
            --repo docker.io/chemdocker \
            --tag ${CI_BRANCH} \
            --all \
            --push --user ${DOCKERHUB_USER} --token ${DOCKERHUB_PASSWORD}
