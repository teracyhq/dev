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

if [[ $BUILD_TYPE == "dev" ]]; then
    deploy_docker_img
fi

if [[ $BUILD_TYPE == "docs" ]]; then
    # build teracy-dev-docs distributed Docker image
    cd docs
    export DOCKER_FILE=Dockerfile
    export CONTAINER_IMAGE=$CI_REGISTRY_IMAGE:$IMAGE_TAG_PREFIX$TAG
    docker_build
    deploy_docker_img
    cd ..
    # allow this to be failed
    deploy_docs
fi
