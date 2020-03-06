#!/bin/bash

set -e

BRANCH_NAME=$1

# TODO(hoatle): remove job type
# job_type convention
if [ -z "${JOB_TYPE}" ]; then
  export IMG_TAG=$(echo "$BRANCH_NAME" | awk '{print tolower($0)}' | sed -e 's/[\/]/-/g' | sed -e 's/[\#]//g');
else
  export IMG_TAG=$(echo "$JOB_TYPE" | awk '{print tolower($0)}' | sed -e 's/[\/]/-/g' | sed -e 's/[\#]//g');
fi

echo "\$IMG_TAG: $IMG_TAG";
