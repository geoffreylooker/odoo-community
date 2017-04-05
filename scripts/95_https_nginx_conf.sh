#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Configuring ssl certificates & nginx"
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

# delete default configuration:
pushd /etc/nginx/sites-enabled/
rm default
popd

# root:www 640?
systemctl enable nginx
service nginx restart

echo "-----------------------------------------------------------"
echo "Start - Configuring ssl certificates & nginx"
echo "-----------------------------------------------------------"

