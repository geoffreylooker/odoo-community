#!/bin/bash

apt-get update -q

xargs -a <(awk '/^\s*[^#]/' 'resources/apt-packages.txt') -r -- \
    apt-get install --no-install-recommends -yq

# Remove unneeded files.
apt-get clean
# rm /var/lib/apt/lists/*_*
