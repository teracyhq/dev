#!/bin/bash

set -e

if [[ $BUILD_TYPE == "docs" ]]; then
    cd docs
    make setup_gh_pages
    make deploy
    cd ..
fi