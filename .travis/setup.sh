#!/bin/bash

#setup travis-ci configuration basing one the being-built branch

if [[ $TRAVIS_BRANCH == 'master' ]] ; then
    export DEPLOY_HTML_DIR=docs
else
    if [[ $TRAVIS_BRANCH == 'develop' ]] ; then
        export DEPLOY_HTML_DIR=docs/develop
    else
        export DEPLOY_HTML_DIR=docs/$TRAVIS_BRANCH
    fi
fi
