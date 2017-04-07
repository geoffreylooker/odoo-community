odoo-community  
=====     
  
### Quick Start  
----------------  
    $ export SECRETS_PASSPHRASE="xxx"
    $ curl -sf https://raw.githubusercontent.com/geoffreylooker/odoo-community/master/bootscrap_install.sh | bash
 
 
### Overview  
---------------- 

#### Install - prerun setup
----------------   
    sudo apt-get update; sudo apt-get install git 
    

#### Install core odoo 10  
----------------   
     # 1
     git clone
     repohome=$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )
     cd "${repohome}"

     # 2 
     "Decrypting secrets"
     
