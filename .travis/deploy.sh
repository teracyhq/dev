#!/bin/bash

. ./.travis/common.sh

docker login -u=$DOCKER_USERNAME -p=$DOCKER_PASSWORD

function deploy_docs {
    cd docs
    make setup_gh_pages
    make deploy
    cd ..
}

function deploy_docker_img {
   docker push $CONTAINER_IMAGE
}

# build teracy-dev-docs distributed Docker image
cd docs
docker_build
deploy_docker_img
cd ..
# allow this to be failed
deploy_docs
