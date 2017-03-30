#!/bin/bash

set -e

# Must be root to use this tool
if [[ ! $EUID -eq 0 ]];then
  if [ -x "$(command -v sudo)" ];then
    exec sudo -H bash "$0" "$@"
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
echo "Decrypting secrets"
echo "-----------------------------------------------------------"
# tar -cf secrets.tar one.txt two.txt three.txt
# openssl aes-256-cbc -k "$SECRETS_PASSPHASE" -in secrets.tar -out secrets.tar.enc -e
if [ -n "$SECRETS_PASSPHASE"  ]; then
  openssl aes-256-cbc -k "$SECRETS_PASSPHASE" -in secrets.tar.enc -out secrets.tar -d
  tar xvf secrets.tar -C "$TMP"
  source "$TMP/install.env"
fi

echo "-----------------------------------------------------------"
echo "Checking Packages Dependencies"
echo "-----------------------------------------------------------"
./scripts/install-apt-packages.sh

echo "-----------------------------------------------------------"
echo "Checking odoo user & log directory"
echo "-----------------------------------------------------------"
# adduser --quiet --system --shell=/bin/bash --home=/opt/odoo --gecos 'ODOO' --group odoo ;
# adduser --quiet odoo sudo ;
# chmod 750 /opt/odoo ;
# mkdir -p /var/log/odoo
# chown odoo:odoo /var/log/odoo

if ! id odoo >/dev/null 2>&1; then
  echo "Configuring odoo user..." ;
  adduser --quiet --system --shell=/bin/bash --home=/opt/odoo --gecos 'ODOO' --group odoo ;
  adduser --quiet odoo sudo ;
  chmod 750 /opt/odoo ;
fi

if [ ! -d /var/log/odoo ]; then
  echo "Configuring odoo logs..."
  mkdir -p /var/log/odoo && chown odoo:odoo /var/log/odoo
fi

echo "-----------------------------------------------------------"
echo "Configuring Postgres DB"
echo "-----------------------------------------------------------"
# avoid permissions error when starting service
#chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key 
systemctl enable postgresql
service postgresql start

#POSTGRES_DB_PWD="$POSTGRES_DB_PWD"
#ODOO_DB_PWD="$ODOO_DB_PWD" - inherit from system
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '"$POSTGRES_DB_PWD"';" 2> /dev/null || true
sudo -u postgres psql -c "CREATE EXTENSION adminpack;" 2> /dev/null || true
sudo -u postgres psql -c "CREATE ROLE odoo CREATEDB NOCREATEUSER NOCREATEROLE INHERIT LOGIN;" 2> /dev/null || true
#sudo -u postgres psql -c "CREATE USER odoo CREATEDB NOCREATEUSER NOCREATEROLE;" 2> /dev/null || true
#sudo -u postgres -c "createuser -s odoo" 2> /dev/null || true

# Setup locale. This prevents Python 3 IO encoding issues.
export LANG=en_US.UTF-8

echo "-----------------------------------------------------------"
echo "Creating symlink for node"
echo "-----------------------------------------------------------"
ln -sf /usr/bin/nodejs /usr/bin/node

echo "-----------------------------------------------------------"
echo "Installing Less CSS using npm"
echo "-----------------------------------------------------------"
npm install -g less

echo "-----------------------------------------------------------"
echo "Installing wkhtmltox"
echo "-----------------------------------------------------------"
curl -sO http://download.gna.org/wkhtmltopdf/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz ;
tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -C /usr/local
ln -sf /usr/local/bin/wkhtmltopdf /usr/bin
ln -sf /usr/local/bin/wkhtmltoimage /usr/bin

echo "-----------------------------------------------------------"
echo "Installing pip, virtualenv, setuptools-odoo & pysftp"
echo "-----------------------------------------------------------"
pip install --upgrade pip virtualenv setuptools-odoo pysftp

echo "-----------------------------------------------------------"
echo "Installing Odoo 10.0 from nightly build"
echo "-----------------------------------------------------------"
pip install -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt
pip install https://nightly.odoo.com/10.0/nightly/src/odoo_10.0.latest.zip
# python -c "import odoo"
# pip list | grep odoo ;

echo "-----------------------------------------------------------"
echo "Installing Odoo 10.0 OCA addons"
echo "-----------------------------------------------------------"
export PIP_FIND_LINKS="https://wheelhouse.odoo-community.org/oca"
pip install -r https://raw.githubusercontent.com/OCA/server-tools/10.0/requirements.txt
pip install odoo10_addon_base_technical_features
pip install odoo10_addon_auto_backup

echo "-----------------------------------------------------------"
echo "Configuring Odoo"
echo "-----------------------------------------------------------"
cat >/opt/odoo/odoo.conf<<EOF
[options]
admin_passwd = "$ODOO_ADMIN_PWD"
;db_name = 
db_host = False
db_port = False
db_user = odoo
db_password = False
db_template = template1
;list_db = False
dbfilter = odoo-*
;addons_path = /opt/odoo/addons
;Log Settings
logfile = /var/log/odoo/odoo$1.log
logrotate = True
log_level = warn
log_db = True
log_db_level = warning
xmlrpc = True
xmlrpc_interface = 127.0.0.1
xmlrpc_port = 8080
proxy_mode = True
;smtp_password = False
;smtp_port = 25
;smtp_server = localhost
;smtp_ssl = False
;smtp_user = False
without_demo = True
EOF
chown odoo:odoo /opt/odoo/odoo.conf
chown 640 /opt/odoo/odoo.conf

echo "-----------------------------------------------------------"
echo "Configuring ssl certificates"
echo "-----------------------------------------------------------"
mkdir -p /etc/nginx/ssl
cp odoo_geoffreylooker_com.* /etc/nginx/ssl/ 
chown -R root:root /etc/nginx/ssl
chmod -R 600 /etc/nginx/ssl
# root:www 640?

echo "-----------------------------------------------------------"
echo "Configuring Nginx"
echo "-----------------------------------------------------------"
cp resources/odoo-nginx.conf /etc/nginx/sites-available/odoo
ln -sf /etc/nginx/sites-available/odoo /etc/nginx/sites-enabled/odoo
chown root:root /etc/nginx/sites-available/odoo
chmod 640 /etc/nginx/sites-available/odoo
# root:www 640?
systemctl enable nginx
service nginx restart

echo "-----------------------------------------------------------"
echo "Configuring Odoo Init File"
echo "-----------------------------------------------------------"
cp resources/odoo-init.sh /etc/init.d/odoo
chmod 755 /etc/init.d/odoo
chown root:root /etc/init.d/odoo
systemctl enable odoo
service odoo restart

echo "-----------------------------------------------------------"
echo "Configuring iptables"
echo "-----------------------------------------------------------"
iptables -A INPUT -p tcp -m tcp --sport 8080 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --dport 8080 -j ACCEPT
iptables-save


# TODO: gcsfuse install
# TODO: clean up
# TODO: upload log

echo "-----------------------------------------------------------"
echo "Finished Odoo installation"
echo "-----------------------------------------------------------"


