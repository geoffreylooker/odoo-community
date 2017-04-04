#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Installing xidel_0.9.6-1_amd64"
echo "-----------------------------------------------------------"

if command -v xidel >/dev/null 2>&1
then 
  echo "xidel is already installed"
else
  scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
  # cd $scratch
  pushd $scratch
  sudo wget https://sourceforge.net/projects/videlibri/files/Xidel/Xidel%200.9.6/xidel_0.9.6-1_amd64.deb
  sudo gdebi --n `basename https://sourceforge.net/projects/videlibri/files/Xidel/Xidel%200.9.6/xidel_0.9.6-1_amd64.deb`
  popd
fi

echo "-----------------------------------------------------------"
echo "Finished - Installing xidel_0.9.6-1_amd64"
echo "-----------------------------------------------------------"

