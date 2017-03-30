#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail
shopt -s globstar

# Check that environment variables are set.
if [[ -z ${PRIVATE_KEY} ]] ; then
  (>&2 echo "PRIVATE_KEY environment variable must be set.")
  exit 1
fi

TMP=$(mktemp -d -t tmp.XXXXXXXXXX) || { echo "creating TMP failed"; exit 1; } 

# Make sure we have git
if [ ! -x /usr/bin/git ] ; then
    sudo apt-get install git -qy || { echo "installing GIT failed"; exit 1; } 
fi

git clone https://github.com/geoffreylooker/odoo-community.git $TMP 
cd $TMP
./install.sh | tee $TMP/install.log
