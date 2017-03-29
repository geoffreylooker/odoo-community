#!/bin/bash


./scripts/install-apt-packages.sh

# Setup locale. This prevents Python 3 IO encoding issues.
export LANG=en_US.UTF-8

# Upgrade pip (debian package version tends to run a few version behind) and
# install virtualenv system-wide.
pip install --upgrade pip virtualenv pysftp

#########################

# create and activate a virtualenv
virtualenv venv
. ./venv/bin/activate

# install Odoo 10.0 nightly
pip install -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt
pip install https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.zip

# check installed packages
python -c "import odoo" ; || exit $?
pip list | grep odoo ;

# install base_import_async from wheelhouse.odoo-community.org
#pip install odoo-addon-base_import_async --find-links=https://wheelhouse.odoo-community.org/oca-10.0

# start odoo
#odoo

exit 0


