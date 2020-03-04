#!/bin/bash

# `source re-export-en-var.sh _DEVELOP` for example
# This script will look through all the en var that has the specified affix, then export
# a new key without the affix with the corresponding values.
# existing: HELLO_DEVELOP=hello
# `. ./re-export-env-var.sh _DEVELOP` will create env var: `HELLO=hello`

affix=$1

echo "Re-export $affix"

while IFS='=' read -ra k;
do
  if [[ "$k" = *$affix* ]]; then
    new_key=${k/"$affix"/""}
    if [ -n "${!k}" ]; then
      echo "${k} env var found, re-export: $new_key=${!k}"
      export $new_key=${!k}
      if [ -n "${GITHUB_WORKSPACE}" ]; then
        # export it here if github actions
        echo "::set-env name=$new_key::${!k}"
      fi
    fi
  fi
done <<< "$(eval env)"
