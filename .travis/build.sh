#!/bin/bash

. ./.travis/common.sh

if [[ $BUILD_TYPE == "dev" ]]; then
    docker_build
    docker run -v $(pwd):/opt/app $CONTAINER_IMAGE rake build
elif [[ $BUILD_TYPE == "docs" ]]; then
    cd docs
    docker_build
    docker run -v $(pwd):/opt/app $CONTAINER_IMAGE make generate
    cd ..
else
    echo 'Wrong build type: $BUILD_TYPE';
    exit 1;
fi