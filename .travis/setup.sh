#!/bin/bash

#setup travis-ci configuration basing one the being-built branch

if [[ $TRAVIS_BRANCH == 'master' ]]
    export DEPLOY_HTML_DIR=''
else if [[ $TRAVIS_BRANCH == 'develop' ]]
    export DEPLOY_HTML_DIR='docs/develop'
fi