#!/bin/bash

exists() 
{
    if command -v "$1" >/dev/null 2>&1
    then
        return 0
    else
        return 1
    fi
}

# if ! exists xxx; then
    # sudo apt-get update; sudo apt-get install xxx;
# else 
    # echo "gcsfuse already installed"
# fi
 
 
 
gcsfuse_apt_install()
{
  echo "installing gcsfuse..."
  echo "deb http://packages.cloud.google.com/apt gcsfuse-$(lsb_release -s -c) main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  sudo apt-get update -yq
  sudo apt-get install gcsfuse -yq
  echo "finished installing gcsfuse..."
}

if ! exists gcsfuse; then
    gcsfuse_apt_install;
else 
    echo "gcsfuse already installed";
fi
 
