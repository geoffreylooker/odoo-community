#!/bin/bash

set -e

apt-get -qq update

xargs -a <(awk '/^\s*[^#]/' 'resources/apt-packages.txt') -r -- \
    apt-get install --no-install-recommends -yqq

# Remove unneeded files.
apt-get clean
# rm /var/lib/apt/lists/*_*
