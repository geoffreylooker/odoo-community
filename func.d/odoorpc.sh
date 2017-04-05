#!/bin/bash

get_odoorpc_config_property () 
{ 
    SECTION=\'$1\';
    PROPERTY=\'$2\';
    python2  <<EOF
import os
import ConfigParser as cp
from pprint import pprint
try:
  config_path = os.environ['ODOORPC_CONF']
  config = cp.ConfigParser()
  config.read(config_path)
  print config.get($SECTION, $PROPERTY)
except:
  print ""
EOF

}

set_odoorpc_config_property () 
{ 
    SECTION=\'$1\';
    PROPERTY=\'$2\';
    VALUE=\'$3\';
    python2  <<EOF
import os
import ConfigParser as cp
try:
  config_path = os.environ['ODOORPC_INI']
  config = cp.ConfigParser()
  config.read(config_path)
  if not config.has_section($SECTION):
    config.add_section($SECTION)
  if $VALUE:
    config.set($SECTION, $PROPERTY, $VALUE)
  else:
    config.remove_option($SECTION, $PROPERTY)
  with open(config_path, 'w') as configfile:
    config.write(configfile)
except:
  pass
EOF

}


# function odoo_change_password () 
# { 
    # NEW_PASSWD=\'$1\';
    # python  <<EOF
# import sys
# import ConfigParser as cp
# from pprint import pprint
# import odoorpc
# try:
  # config_path = os.environ['ODOORPC_INI']
  # config = cp.ConfigParser()
  # config.read(config_path)
  # host = Config.get('host', 'host')
  # prt = int(Config.get('host', 'port'))  
  # db_name = Config.get('database', 'db_name')
  # user = Config.get('database', 'user')
  # passwd = Config.get('database', 'passwd')
  # odoo = odoorpc.ODOO(host, port=prt)
  # odoo.db.change_password(passwd, "$NEW_PASSWD")
  # print "$NEW_PASSWD"
# except:
  # print "fail"
# EOF
# }


function odoo_create_db () 
{ 
    HOST_ARG=$(get_odoorpc_config_property "host" "host");
    PORT_ARG=$(get_odoorpc_config_property "host" "port");
    USR_ARG=$(get_odoorpc_config_property "database" "user");
    USR_PWD=$(get_odoorpc_config_property "database" "passwd");
    #DB_NAME=${get_odoorpc_config_property "database" "db_name");
    DB_NAME=\'$1\';
    python2  <<EOF
import sys
from pprint import pprint
import odoorpc
try:
  odoo = odoorpc.ODOO("$HOST_ARG", port=$PORT_ARG)
  if "$DB_NAME" not in odoo.db.list():
      odoo.db.create("$USR_PWD", "$DB_NAME", False, 'en_US', "$USR_PWD")
      print "DB $DB_NAME created."
  else:
      print "DB $DB_NAME already exists in db list."
except:
  print ""
EOF
}

function odoo_install_modules () 
{ 
    HOST_ARG=$(get_odoorpc_config_property "host" "host");
    PORT_ARG=$(get_odoorpc_config_property "host" "port");
    USR_ARG=$(get_odoorpc_config_property "database" "user");
    USR_PWD=$(get_odoorpc_config_property "database" "passwd");
    DB_NAME=$(get_odoorpc_config_property "database" "db_name");
    #DB_NAME=\'$1\';
    MODULES=$(get_gcloud_config_property "modules" "install_list");
    python2 <<EOF
import sys
from pprint import pprint
import odoorpc
#try:
def main(list):
    odoo = odoorpc.ODOO("$HOST_ARG", port=$PORT_ARG)
    odoo.login("$DB_NAME", "$USR_ARG", "$USR_PWD")
    Module = odoo.env['ir.module.module']
    for item in list:
    # Get the module ids by name
    module_ids = Module.search([['name', '=', item]])
    for module in Module.browse(module_ids):
        if module.state == 'installed':
            # If installed, just print that it has install
            sys.stdout.write("Already installed\n")
        else:
            # Otherwise, install it
            sys.stdout.write("Installing \n")
            module.button_immediate_install()
            sys.stdout.write("Done \n")
#except:
 # sys.stderr.write("xxx \n")
EOF
}

function odoo_install_modules () 
{
    HOST_ARG=$(get_odoorpc_config_property "host" "host");
    PORT_ARG=$(get_odoorpc_config_property "host" "port");
    USR_ARG=$(get_odoorpc_config_property "database" "user");
    USR_PWD=$(get_odoorpc_config_property "database" "passwd");
    DB_NAME=$(get_odoorpc_config_property "database" "db_name");
    #DB_NAME=\'$1\';
    MODULES=$(get_gcloud_config_property "modules" "install_list");
    python2 <<EOF
#!/usr/bin/env python
import sys
import ConfigParser
from pprint import pprint
import odoorpc

def  main(list):
    # Read configurations and parse them to variables
    Config = ConfigParser.ConfigParser()
    Config.read("./config.ini")

    host = Config.get('host', 'host')
    prt = int(Config.get('host', 'port'))

    db_name = Config.get('database', 'db_name')
    user = Config.get('database', 'user')
    passwd = Config.get('database', 'passwd')

    # Prepare the connection to the server
    odoo = odoorpc.ODOO("$HOST", port=$PORT)    

    # Check if db_name exist in db list
    if db_name not in odoo.db.list():
        sys.exit("DB %s not found in db list" % "$DB_NAME")
    
    # Login
    odoo.login("$DB_NAME", "$DB_USR", "$DB_PWD")
    
    # Module is 'ir.module.module'
    Module = odoo.env['ir.module.module']
    
    for item in list:
        module_ids = Module.search([['name', '=', item]])
        for module in Module.browse(module_ids):
            if module.state == 'installed':
                # If installed, just print that it has install
                print "%s has already been installed." % module.name
            else:
                # Otherwise, install it
                sys.stdout.write("Installing %s ... " % module.name)
                module.button_immediate_install()
                print "Done."
    
if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("Usage:\n./install_module.py <module 1> <module 2> .. <module n>")
    
    modules_list = sys.argv
    modules_list.pop(0)
    
    main(modules_list)      

EOF
}
#########

python <<EOF
#!/usr/bin/python
import odoorpc
odoo = odoorpc.ODOO('localhost', port=8069)
odoo.login('odoo-10-prd', 'admin', "$DB_PWD")
Module = odoo.env['ir.module.module']
module_id = Module.search([('name', '=', 'dashboards')])
Module.button_immediate_install(module_id)
EOF

