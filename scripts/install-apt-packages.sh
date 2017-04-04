#!/bin/bash

set -e

apt-get update -q

xargs -a <(awk '/^\s*[^#]/' 'dependencies/apt-packages.txt') -r -- \
    apt-get install --no-install-recommends -yq

# Remove unneeded files.
apt-get clean
# rm /var/lib/apt/lists/*_*
