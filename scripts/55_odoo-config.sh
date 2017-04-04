#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Configuring Odoo"
echo "-----------------------------------------------------------"

cat >/opt/odoo/odoo.conf<<EOF
[options]
admin_passwd = ${ODOO_ADMIN_PWD}
;db_name = 
db_host = False
db_port = False
db_user = odoo
db_password = False
db_template = template1
;list_db = False
dbfilter = .*
;addons_path = /opt/odoo/addons
;Log Settings
logfile = /var/log/odoo/odoo$1.log
logrotate = True
log_level = warn
log_db = True
log_db_level = warning
xmlrpc = True
xmlrpc_interface = 127.0.0.1
xmlrpc_port = 8069
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
echo "Configuring Odoo Init File"
echo "-----------------------------------------------------------"
cp resources/odoo-init.sh /etc/init.d/odoo
chmod 755 /etc/init.d/odoo
chown root:root /etc/init.d/odoo
systemctl enable odoo
service odoo restart


echo "-----------------------------------------------------------"
echo "Finished - Configuring Odoo"
echo "-----------------------------------------------------------"

