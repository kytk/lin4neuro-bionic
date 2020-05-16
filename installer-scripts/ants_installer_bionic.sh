#!/bin/bash

echo "Install ANTs"
cd $HOME/Downloads

if [ ! -e 'ANTs.zip' ]; then
  curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/ANTs.zip
fi

cd /usr/local
sudo unzip ~/Downloads/ANTs.zip

grep ANTs ~/.bash_aliases > /dev/null
if [ $? -eq 1 ]; then
    echo '' >> ~/.bash_aliases
    echo '#ANTs' >> ~/.bash_aliases
    echo 'export ANTSPATH=/usr/local/ANTs/bin' >> ~/.bash_aliases
    echo 'export PATH=$PATH:$ANTSPATH' >> ~/.bash_aliases
fi

echo "Finished!"
sleep 5
exit
