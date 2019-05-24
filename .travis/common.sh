#!/bin/bash

function docker_build {
    docker build -f $DOCKER_FILE \
            --build-arg CI_BUILD_ID=$TRAVIS_BUILD_ID \
            --build-arg CI_BUILD_REF=$TRAVIS_COMMIT \
            --build-arg CI_BUILD_REF_NAME=$TRAVIS_BRANCH \
            --build-arg CI_BUILD_TIME=$CI_BUILD_TIME \
            --build-arg CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
            --build-arg CI_PROJECT_NAME=$TRAVIS_REPO_SLUG \
            --pull -t $CONTAINER_IMAGE .
}
