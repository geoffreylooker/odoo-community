
readonly ODOO_DIR="/opt/odoo-dev"

TMP=$(mktemp -d -t tmp.XXXXXXXXXX) || { echo "creating TMP failed"; exit 1; } 

# Make sure we have git
if [ ! -x /usr/bin/git ] ; then
    sudo apt-get install git -qy || { echo "installing GIT failed"; exit 1; } 
fi

cd $TMP && \
  git clone https://github.com/geoffreylooker/odoo-community.git && \
  ./install.sh
