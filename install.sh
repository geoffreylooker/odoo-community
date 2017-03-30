#!/bin/bash

set -e

readonly ODOO_DIR="/opt/odoo-dev"

echo "running install script"

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

echo "installing apt packages"
./scripts/install-apt-packages.sh

# Setup locale. This prevents Python 3 IO encoding issues.
export LANG=en_US.UTF-8

# Upgrade pip (debian package version tends to run a few version behind) and
# install virtualenv system-wide.
pip install --upgrade pip virtualenv pysftp

exit 0
