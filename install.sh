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

# Setup locale. This prevents Python 3 IO encoding issues.
export LANG=en_US.UTF-8

echo "-----------------------------------------------------------"
echo "Upgrading pip and installing virtualenv system-wide."
echo "-----------------------------------------------------------"
pip install --upgrade pip virtualenv

echo "-----------------------------------------------------------"
echo "Installing Less CSS using"
echo "-----------------------------------------------------------"
ln -sf /usr/bin/nodejs /usr/bin/node
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
tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz ;
cp wkhtmltox/bin/wkhtmltopdf /usr/bin/ ;

echo "-----------------------------------------------------------"
echo "Installing Odoo 10.0 OCA addons"
echo "-----------------------------------------------------------"
export PIP_FIND_LINKS="https://wheelhouse.odoo-community.org/oca"
pip install -r https://raw.githubusercontent.com/OCA/server-tools/10.0/requirements.txt
pip install odoo10_addon_base_technical_features
pip install odoo10_addon_auto_backup

echo "-----------------------------------------------------------"
echo "Decrypting secrets"
echo "-----------------------------------------------------------"
# create tar: tar -cf secrets.tar xxx.key yyy.crt zzz.ca-bundle"
# encrypt with: openssl aes-256-cbc -k public_key.pem -in secrets.tar -out secrets.tar -e
if [ -n "$PRIVATE_KEY"  ]; then
  openssl aes-256-cbc -k "$PRIVATE_KEY" -in secrets.tar.enc -out secrets.tar -d
  tar xvf secrets.tar -C "$TMP"
fi

echo "-----------------------------------------------------------"
echo "Installing ssl certificates"
echo "-----------------------------------------------------------"
mkdir -p /etc/nginx/ssl
cp odoo_geoffreylooker_com.* /etc/nginx/ssl/ 
chown -R root:root /etc/nginx/ssl
chmod -R 600 /etc/nginx/ssl

echo "-----------------------------------------------------------"
echo "Finished Odoo installation"
echo "-----------------------------------------------------------"


