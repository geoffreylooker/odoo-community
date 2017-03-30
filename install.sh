#!/bin/bash

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

echo "-----------------------------------------------------------"
echo "Starting Odoo installation"
echo "-----------------------------------------------------------"

echo "-----------------------------------------------------------"
echo "Installing Packages Dependencies"
echo "-----------------------------------------------------------"
./scripts/install-apt-packages.sh

echo "-----------------------------------------------------------"
echo "Creating odoo system user"
echo "-----------------------------------------------------------"
adduser --quiet --system --shell=/bin/bash --home=/opt/odoo --gecos 'ODOO' --group odoo ;
adduser --quiet odoo sudo ;
chmod 750 /opt/odoo

echo "-----------------------------------------------------------"
echo "Creating odoo log directory"
echo "-----------------------------------------------------------"
mkdir -p /var/log/odoo
chown odoo:odoo /var/log/odoo

echo "-----------------------------------------------------------"
echo "Configuring Postgres DB"
echo "-----------------------------------------------------------"
POSTGRES_DB_PWD="$POSTGRES_DB_PWD"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '"$POSTGRES_DB_PWD"';" 2> /dev/null || true
sudo -u postgres psql -c "CREATE EXTENSION adminpack;" 2> /dev/null || true

# ODOO_DB_PWD="$ODOO_DB_PWD" - should inherit from system as user names align
#sudo -u postgres psql -c "CREATE USER odoo CREATEDB NOCREATEUSER NOCREATEROLE;" 2> /dev/null || true
sudo -u postgres psql -c "CREATE ROLE odoo CREATEDB NOCREATEUSER NOCREATEROLE INHERIT LOGIN;" 2> /dev/null || true
#sudo -u postgres -c "createuser -s odoo" 2> /dev/null || true
# createuser --createdb --username postgres --no-createrole --no-superuser --pwprompt odoo ;

# maybe required?
#/etc/ssl/private/ssl-cert-snakeoil.key
#chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key 


# Setup locale. This prevents Python 3 IO encoding issues.
export LANG=en_US.UTF-8

echo "-----------------------------------------------------------"
echo "Upgrading pip and installing virtualenv system-wide."
echo "-----------------------------------------------------------"
pip install --upgrade pip virtualenv

echo "-----------------------------------------------------------"
echo "Creating symlink for node"
echo "-----------------------------------------------------------"
ln -sf /usr/bin/nodejs /usr/bin/node

echo "-----------------------------------------------------------"
echo "Installing Less CSS using npm"
echo "-----------------------------------------------------------"
npm install -g less

echo "-----------------------------------------------------------"
echo "Installing Odoo 10.0 from nightly build"
echo "-----------------------------------------------------------"
pip install -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt
pip install https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.zip
# python -c "import odoo"
#pip list | grep odoo ;

echo "-----------------------------------------------------------"
echo "Installing/upgrading setuptools-odoo and pysftp"
echo "-----------------------------------------------------------"
pip install --upgrade setuptools-odoo pysftp

echo "-----------------------------------------------------------"
echo "Installing wkhtmltox"
echo "-----------------------------------------------------------"
curl -sO http://download.gna.org/wkhtmltopdf/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz ;
tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -C /usr/local
ln -sf /usr/local/bin/wkhtmltopdf /usr/bin
ln -sf /usr/local/bin/wkhtmltoimage /usr/bin

echo "-----------------------------------------------------------"
echo "Installing Odoo 10.0 OCA addons"
echo "-----------------------------------------------------------"
export PIP_FIND_LINKS="https://wheelhouse.odoo-community.org/oca"
pip install -r https://raw.githubusercontent.com/OCA/server-tools/10.0/requirements.txt
pip install odoo10_addon_base_technical_features
pip install odoo10_addon_auto_backup


echo "-----------------------------------------------------------"
echo "Finished Odoo installation"
echo "-----------------------------------------------------------"


