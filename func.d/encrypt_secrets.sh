#!/bin/bash

#echo "-----------------------------------------------------------"
#echo "Decrypting secrets"
#echo "-----------------------------------------------------------"
# tar -cf secrets.tar one.txt two.txt three.txt
# openssl aes-256-cbc -k "$SECRETS_PASSPHASE" -in secrets.tar -out secrets.tar.enc -e
#if [ -n "$SECRETS_PASSPHRASE"  ]; then
#  openssl aes-256-cbc -k "$SECRETS_PASSPHRASE" -in secrets.tar.enc -out secrets.tar -d
#  tar xvf secrets.tar 
#  source install.env
#fi

# Check that environment variables are set.
if [[ -z ${SECRETS_PASSPHRASE} ]] ; then
  (>&2 echo "SECRETS_PASSPHRASE environment variable must be set.")
  #exit 1
fi

# secure secrets
tar -cf secrets.tar odoo_geoffreylooker_com.crt odoo_geoffreylooker_com.key \
   odoo_geoffreylooker_com.ca-bundle install.env \
   credentials.json \
  # odoorpc_config.ini 
 
openssl aes-256-cbc -k "$SECRETS_PASSPHRASE" -in secrets.tar -out secrets.tar.enc -e

