#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Installing WkHtmlToPdf 0.12.1"
echo "-----------------------------------------------------------"

#scratch=$(mktemp -d -t tmp.XXXXXXXXXX) || return 9
#cd $scratch
#curl -s -k http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb -O
#sudo dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb
#cd /usr/local/bin
#sudo cp wkhtmltoimage /usr/bin/wkhtmltoimage
#sudo cp wkhtmltopdf /usr/bin/wkhtmltopdf

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
cd $scratch
sudo wget http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
sudo gdebi --n `basename http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb`
sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin

echo "-----------------------------------------------------------"
echo "Finished - Install WkHtmlToPdf 0.12.1"
echo "-----------------------------------------------------------"
