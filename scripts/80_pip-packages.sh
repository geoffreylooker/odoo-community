#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Installing Pip-Packages Dependencies"
echo "-----------------------------------------------------------"
sudo -H pip install -U pip virtualenv

echo "-----------------------------------------------------------"
echo "Installing virtualenv, setuptools & setuptools-odoo"
echo "-----------------------------------------------------------"
sudo -H pip install -U setuptools
sudo -H pip install -U setuptools-odoo 

echo "-----------------------------------------------------------"
echo "Installing dependencies/pip-packages.txt"
echo "-----------------------------------------------------------"
#sudo -H pip install -U -r dependencies/pip-packages.txt
sudo -H pip install -U -r pysftp odoorpc

#echo "-----------------------------------------------------------"
#echo "Installing dependencies/pip-url-requirement-files.txt"
#echo "-----------------------------------------------------------"
#xargs -a <(awk '/^\s*[^#]/' 'dependencies/pip-url-requirement-files.txt') -r -- \
#    sudo pip install -r 
#

echo "-----------------------------------------------------------"
echo "Installing Odoo 10.0 from nightly build"
echo "-----------------------------------------------------------"
sudo -H pip install -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt
sudo -H pip install https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.zip
# python -c "import odoo"
# pip list | grep odoo ;

echo "-----------------------------------------------------------"
echo "Finished - Installing Pip-Packages Dependencies"
echo "-----------------------------------------------------------"


# pip 
#virtualenv
#setuptools
#setuptools-odoo 
# pysftp
#
#
#echo "-----------------------------------------------------------"
#echo "Installing Odoo 10.0 from nightly build"
#echo "-----------------------------------------------------------"
#pip install -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt
#pip install https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.zip
# python -c "import odoo"
# pip list | grep odoo ;
#
#echo "-----------------------------------------------------------"
#echo "Installing Odoo 10.0 OCA addons"
#echo "-----------------------------------------------------------"
#export PIP_FIND_LINKS="https://wheelhouse.odoo-community.org/oca"
#pip install -r https://raw.githubusercontent.com/OCA/server-tools/10.0/requirements.txt
#pip install odoo10_addon_base_technical_features
#
#pip install pysftp
#pip install odoo10_addon_auto_backup
#
#######
#
#
# move following to apt-packages.txt
# 30 March 2017
# stock-logistics-warehouse
#python-levenshtei
#
# 31 March 2017
# stock-logistics-warehouse
# stock-logistics-tracking
# stock-logistics-barcode
#python-levenshtein
#
# 31 March 2017
# hw_driver - Barcode Scanner Hardware Driver
#python-evdev
#
#odooclient==0.5.1
# odoorpc


