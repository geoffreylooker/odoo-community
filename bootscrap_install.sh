#!/bin/bash

readonly ODOO_DIR="/opt/odoo-dev"

TMP=$(mktemp -d -t tmp.XXXXXXXXXX) || { echo "creating TMP failed"; exit 1; } 

# Must be root to use this tool
if [[ ! $EUID -eq 0 ]];then
  if [ -x "$(command -v sudo)" ];then
    exec sudo bash "$0" "$@"
    exit $?
  else
    echo "::: sudo is needed to run this commands.  Please run this script as root or install sudo."
    exit 1
  fi
fi

# Make sure we have git
if [ ! -x /usr/bin/git ] ; then
    sudo apt-get install git
fi

mkdir -p repos && \
  cd $TMP && \
  git clone https://github.com/geoffreylooker/odoo-community.git && \
  ./install.sh

