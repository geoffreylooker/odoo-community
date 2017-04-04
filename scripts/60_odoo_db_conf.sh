#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Configuring Odoo DB"
echo "-----------------------------------------------------------"


dbname='odoo-10-prd'
admpwd=${ODOO_ADMIN_PWD}
usrpwd=${ODOO_ADMIN_PWD}

python <<EOF
#!/usr/bin/python

import odoorpc

# Prepare the connection to the server
odoo = odoorpc.ODOO('localhost', port=8069)

odoo.db.create($admpwd, $dbname, False, 'en_US', $usrpwd) 

##odoo.db.change_password('super_admin_passwd', 'new_admin_passwd') 
#odoo.db.drop('super_admin_passwd', 'test') 
#dump = odoo.db.dump('super_admin_passwd', 'prod') 
#odoo.db.duplicate('super_admin_passwd', 'prod', 'test') 
#odoo.db.list() 
#odoo.db.restore('super_admin_passwd', 'test', dump_file) 

EOF


echo "-----------------------------------------------------------"
echo "Finished - Configuring Odoo DB"
echo "-----------------------------------------------------------"
