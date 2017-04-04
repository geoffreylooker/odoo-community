#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Installing Pip-Packages Dependencies"
echo "-----------------------------------------------------------"
sudo pip install -U pip

echo "-----------------------------------------------------------"
echo "Installing virtualenv, setuptools & setuptools-odoo"
echo "-----------------------------------------------------------"
sudo pip install -U virtualenv setuptools setuptools-odoo 

echo "-----------------------------------------------------------"
echo "Installing dependencies/pip-packages.txt"
echo "-----------------------------------------------------------"
sudo pip install -U -r dependencies/pip-packages.txt

echo "-----------------------------------------------------------"
echo "Installing dependencies/pip-url-requirement-files.txt"
echo "-----------------------------------------------------------"
xargs -a <(awk '/^\s*[^#]/' 'dependencies/pip-url-requirement-files.txt') -r -- \
    sudo pip install -U -r 

echo "-----------------------------------------------------------"
echo "Finished - Installing Pip-Packages Dependencies"
echo "-----------------------------------------------------------"
