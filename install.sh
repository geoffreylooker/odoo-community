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

# Less CSS via nodejs 
# sudo apt-get install -y npm 
ln -sf /usr/bin/nodejs /usr/bin/node
# Once npm is installed, use it to install less:
npm install -g less

# install Odoo 10.0 nightly
pip install -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt
pip install https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.zip

# check installed packages
python -c "import odoo" && echo "odoo python module installed";
#pip list | grep odoo ;

echo "finished $0"

exit 0
