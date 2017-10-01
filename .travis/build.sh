#!/bin/bash

set -e

. ./.travis/common.sh

if [[ $BUILD_TYPE == "dev" ]]; then
    docker_build
    docker run --rm -v $(pwd):/opt/app $CONTAINER_IMAGE rake build
    docker run --rm -v $(pwd):/opt/app $CONTAINER_IMAGE bundle exec rspec
elif [[ $BUILD_TYPE == "docs" ]]; then
    cd docs
    export DOCKER_FILE=Dockerfile.build
    export BUILD_TAG="_build"
    export CONTAINER_IMAGE=$CI_REGISTRY_IMAGE:$IMAGE_TAG_PREFIX$TAG$BUILD_TAG
    docker_build
    docker run -v $(pwd):/opt/app $CONTAINER_IMAGE make generate
    cd ..
else
    echo 'Wrong build type: $BUILD_TYPE';
    exit 1;
fi
