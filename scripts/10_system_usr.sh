#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Start - odoo system user & log directory"
echo "-----------------------------------------------------------"

# adduser --quiet --system --shell=/bin/bash --home=/opt/odoo --gecos 'ODOO' --group odoo ;
# adduser --quiet odoo sudo ;
# chmod 750 /opt/odoo ;
# mkdir -p /var/log/odoo
# chown odoo:odoo /var/log/odoo

if ! id odoo >/dev/null 2>&1; then
  echo "Configuring odoo system user..." ;
  adduser --quiet --system --shell=/bin/bash --home=/opt/odoo --gecos 'ODOO' --group odoo ;
  adduser --quiet odoo sudo ;
  chmod 750 /opt/odoo ;
fi

if [ ! -d /var/log/odoo ]; then
  echo "Configuring odoo log directory..."
  mkdir -p /var/log/odoo && chown odoo:odoo /var/log/odoo
fi

echo "-----------------------------------------------------------"
echo "Finished - odoo system user & log directory"
echo "-----------------------------------------------------------"



