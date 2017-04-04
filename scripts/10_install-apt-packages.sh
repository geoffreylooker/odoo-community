#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Installing Apt-Packages Dependencies"
echo "-----------------------------------------------------------"

apt-get update -q

xargs -a <(awk '/^\s*[^#]/' 'dependencies/apt-packages.txt') -r -- \
    apt-get install --no-install-recommends -yq

# Remove unneeded files.
apt-get clean
# rm /var/lib/apt/lists/*_*

echo "-----------------------------------------------------------"
echo "Finished - Installing Apt-Packages Dependencies"
echo "-----------------------------------------------------------"
