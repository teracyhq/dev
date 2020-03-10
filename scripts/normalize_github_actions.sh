#!/bin/bash

set -e

contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

# allow to specify the target branch name, otherwise, use $GITHUB_REF to extract info
if [ -z "${BRANCH_NAME}" ]; then
  # see: https://stackoverflow.com/questions/3162385/how-to-split-a-string-in-shell-and-get-the-last-field
  export BRANCH_NAME=$(echo ${GITHUB_REF} | sed -e "s/refs\/heads\///g" | sed -e "s/refs\/tags\///g" \
    | sed -e "s/refs\/pull\///g" |  sed -e "s/\//-/g")
fi

echo "\$BRANCH_NAME: $BRANCH_NAME"

# affix
AFFIX=$(echo "$BRANCH_NAME" | awk '{print tolower($0)}' | sed -e 's/[\/]/-/g' | sed -e 's/[\#]//g' | sed -e 's/[\.]/_/g');

. ./scripts/re_export_env_var.sh _${AFFIX^^}

if contains "$GITHUB_REF" "refs/tags/"; then
  . ./scripts/normalize_image_tag.sh $BRANCH_NAME
else
  CI_COMMIT_SHORT_SHA=$(git rev-parse --short HEAD)
  . ./scripts/normalize_image_tag.sh $BRANCH_NAME-$CI_COMMIT_SHORT_SHA
fi


# push to the registry if $CI_REGISTRY_IMAGE is specified and $DOCKER_PUSH_ENABLED is not specified
if [ -n "${CI_REGISTRY_IMAGE}" ] && [ -z "$DOCKER_PUSH_ENABLED" ] ; then
  export DOCKER_PUSH_ENABLED=true

  if contains "$CI_REGISTRY_IMAGE" "/"; then
    # gcr.io/hoatle/teracy/dev, registry.gitlab.com/hoatle/teracy-dev for example
    export DOCKER_LOGIN_SERVER=$CI_REGISTRY_IMAGE # maybe use only domain part? fix this when bug happens
  else
    # CI_REGISTRY_IMAGE is a docker hub username (without any slash), hoatle, for example
    export DOCKER_LOGIN_SERVER=https://index.docker.io/v1/ # or https://registry-1.docker.io/v2/ ?
  fi
  echo "::set-env name=DOCKER_LOGIN_SERVER::$DOCKER_LOGIN_SERVER"

fi

if [ -z "${CI_REGISTRY_IMAGE}" ]; then
  # not defined => set default
  export GITHUB_REPOSITORY=$(echo "${GITHUB_REPOSITORY}" | awk '{print tolower($0)}')
  export CI_REGISTRY_IMAGE=docker.pkg.github.com/$GITHUB_REPOSITORY
  echo "CI_REGISTRY_IMAGE env var not defined, set default to: $CI_REGISTRY_IMAGE"
  echo "::set-env name=GITHUB_PACKAGE_REGISTRY::true"
  if [ -z "$DOCKER_USERNAME" ] && [ -z "$DOCKER_PASSWORD" ] ; then
    export DOCKER_USERNAME=$(echo "${GITHUB_REPOSITORY}" | cut -d'/' -f1)
    export DOCKER_PASSWORD=${GITHUB_TOKEN}
  fi

fi


if contains "$CI_REGISTRY_IMAGE" "gcr.io" ; then
  echo "::set-env name=PUSH_TO_GCR::true"
fi


echo "::set-env name=IMG_TAG::$IMG_TAG"
echo "::set-env name=CI_REGISTRY_IMAGE::$CI_REGISTRY_IMAGE"
echo "::set-env name=DOCKER_USERNAME::$DOCKER_USERNAME"
echo "::set-env name=DOCKER_PASSWORD::$DOCKER_PASSWORD"
echo "::set-env name=DOCKER_PUSH_ENABLED::$DOCKER_PUSH_ENABLED"
