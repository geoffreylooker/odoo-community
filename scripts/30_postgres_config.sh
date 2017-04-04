#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - Configuring Postgres DB"
echo "-----------------------------------------------------------"
systemctl enable postgresql
service postgresql start 

#POSTGRES_DB_PWD="$POSTGRES_DB_PWD"
#ODOO_DB_PWD="$ODOO_DB_PWD" - inherit from system
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '"$POSTGRES_DB_PWD"';" 2> /dev/null || true
sudo -u postgres psql -c "CREATE EXTENSION adminpack;" 2> /dev/null || true
sudo -u postgres psql -c "CREATE ROLE odoo CREATEDB NOCREATEUSER NOCREATEROLE INHERIT LOGIN;" 2> /dev/null || true
#sudo -u postgres psql -c "CREATE USER odoo CREATEDB NOCREATEUSER NOCREATEROLE;" 2> /dev/null || true
#sudo -u postgres -c "createuser -s odoo" 2> /dev/null || true

echo "-----------------------------------------------------------"
echo "Finished - Configuring Postgres DB"
echo "-----------------------------------------------------------"
