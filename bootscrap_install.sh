#!/bin/bash

#set -o nounset
set -o errexit
set -o pipefail
shopt -s globstar

# Check that environment variables are set.
if [[ -z ${PRIVATE_KEY} ]] ; then
  (>&2 echo "PRIVATE_KEY environment variable must be set.")
  exit 1
fi

# Make sure we have git
if [ ! -x /usr/bin/git ] ; then
    DEBIAN_FRONTEND=noninteractive apt-get install git -yq
fi

TMP=$(mktemp -d -t tmp.XXXXXXXXXX)

git clone https://github.com/geoffreylooker/odoo-community.git $TMP 
cd $TMP
./install.sh 2>&1 | tee $TMP/install.log
