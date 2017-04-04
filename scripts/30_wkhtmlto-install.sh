#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Installing WkHtmlToPdf 0.12.1"
echo "-----------------------------------------------------------"

if command -v wkhtmltopdf >/dev/null 2>&1
then 
  echo "wkhtmltopdf is already installed"
else
  echo "wkhtmltopdf is not installed"
  scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
  #cd $scratch
  pushd $scratch
  sudo wget -nv http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb
  sudo gdebi --n `basename http://download.gna.org/wkhtmltopdf/0.12/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb`
  sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
  sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin
  popd
fi 

echo "-----------------------------------------------------------"
echo "Finished - Install WkHtmlToPdf 0.12.1"
echo "-----------------------------------------------------------"

