#!/bin/bash

set -e

. ./.travis/common.sh

if [[ $BUILD_TYPE == "dev" ]]; then
    docker_build
    docker run --rm -v $(pwd):/opt/app $CONTAINER_IMAGE rake build
    docker run --rm -v $(pwd):/opt/app $CONTAINER_IMAGE bundle exec rspec
elif [[ $BUILD_TYPE == "docs" ]]; then
    cd docs
    docker_build
    docker run -v $(pwd):/opt/app $CONTAINER_IMAGE make generate
    cd ..
else
    echo 'Wrong build type: $BUILD_TYPE';
    exit 1;
fi