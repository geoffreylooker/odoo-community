#!/bin/bash


function odoo_change_password () 
{ 
    HOST_ARG=${HOST:-"localhost"};
    PORT_ARG=${PORT:-8069};
    USR_ARG=${USR:-"admin"};
    USR_PWD=${PASSWD:-"admin"};
    NEW_PWD=${NEW:-"aaaaa"};
    python  <<EOF
import sys
from pprint import pprint
import odoorpc
try:
  odoo = odoorpc.ODOO("$HOST_ARG", port=$PORT_ARG)
  odoo.db.change_password("$USR_PWD", "$NEW_PWD")
  print "$NEW_PWD"
except:
  print ""
EOF
}

function odoo_create_db () 
{ 
    HOST_ARG=${HOST:-"localhost"};
    PORT_ARG=${PORT:-8069};
    USR_ARG=${USR:-"admin"};
    USR_PWD=${PASSWD:-"admin"};
    DB_NAME=${DB_NAME:-"prod"};
    python  <<EOF
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
    HOST_ARG=${HOST:-"localhost"};
    PORT_ARG=${PORT:-8069};
    USR_ARG=${USR:-"admin"};
    USR_PWD=${PASSWD:-"aaaaa"};
    DB_NAME=${DB_NAME:-"prod"};
    MODULES=${MODULES:-"project"};
    python -c <<EOF
import sys
from pprint import pprint
import odoorpc
try:
  #if len(sys.argv) < 2:
  #   print "Usage:\n./install_module.py <module 1> <module 2> .. <module n>"
  #   print sys.argv
  cmdargs = str(sys.argv)
  #modules_list = sys.argv
  #modules_list.pop(0)
  odoo = odoorpc.ODOO("$HOST_ARG", port=$PORT_ARG)
  sys.stderr.write("ttt \n")
  #if "$DB_NAME" not in odoo.db.list():
  #    #print "$DB_NAME not found in db list."
  #    sys.exit("DB_NAME not found in db list.\n")
  #else:
  odoo.login("$DB_NAME", "$USR_ARG", "$USR_PWD")
  Module = odoo.env['ir.module.module']
  for item in cmdargs:
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
except:
  sys.stderr.write("xxx \n")
EOF
}
