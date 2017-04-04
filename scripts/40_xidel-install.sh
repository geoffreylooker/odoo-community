#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Installing xidel_0.9.6-1_amd64"
echo "-----------------------------------------------------------"

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
cd $scratch
sudo wget https://sourceforge.net/projects/videlibri/files/Xidel/Xidel%200.9.6/xidel_0.9.6-1_amd64.deb
sudo gdebi --n `basename https://sourceforge.net/projects/videlibri/files/Xidel/Xidel%200.9.6/xidel_0.9.6-1_amd64.deb`

echo "-----------------------------------------------------------"
echo "Finished - Installing xidel_0.9.6-1_amd64"
echo "-----------------------------------------------------------"
