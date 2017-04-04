#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Add Apt-Packages Repositories"
echo "-----------------------------------------------------------"

# gcsfuse
echo "deb http://packages.cloud.google.com/apt gcsfuse-$(lsb_release -s -c) main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# next..


echo "-----------------------------------------------------------"
echo "Finished - Add Apt-Packages Repositories"
echo "-----------------------------------------------------------"
