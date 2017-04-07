

 
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
 
# sudo nano /etc/fstab
## gceprd-test /mnt/test gcsfuse rw,allow_other,uid=1001,gid=1002,suid,dev,implicit_dirs
# sudo mount /mnt/test
# sudo fusermount -u /mnt/test
## my-bucket /mount/point gcsfuse rw,noauto,user,key_file=/path/to/key.json

# https://bbs.archlinux.org/viewtopic.php?id=119261
# chmod o+w /mnt/storage/DATA1  (same for DATA2)


