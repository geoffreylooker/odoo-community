#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get update -q

xargs -a <(awk '/^\s*[^#]/' 'resources/apt-packages.txt') -r -- \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -yq

# Remove unneeded files.
DEBIAN_FRONTEND=noninteractive apt-get clean
# rm /var/lib/apt/lists/*_*
