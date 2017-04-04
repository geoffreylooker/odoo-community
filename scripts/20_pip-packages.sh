#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Installing Pip-Packages Dependencies"
echo "-----------------------------------------------------------"

sudo pip install -U pip
sudo pip install -U virtualenv setuptools setuptools-odoo 

sudo pip install -U -r dependencies/pip-packages.txt

xargs -a <(awk '/^\s*[^#]/' 'dependencies/pip-url-requirement-files.txt') -r -- \
    sudo pip install -U -r 

echo "-----------------------------------------------------------"
echo "Finished - Installing Pip-Packages Dependencies"
echo "-----------------------------------------------------------"
