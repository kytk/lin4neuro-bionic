#!/bin/bash

echo "Install 3D-Slicer"
cd $HOME/Downloads

if [ ! -e 'Slicer-4.10.2-linux-amd64.tar.gz' ]; then
  curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/Slicer-4.10.2-linux-amd64.tar.gz
fi

cd /usr/local
#remove previous version
sudo rm -rf Slicer
sudo tar xvzf ~/Downloads/Slicer-4.10.2-linux-amd64.tar.gz
sudo mv Slicer-4.10.2-linux-amd64 Slicer

grep Slicer ~/.bash_aliases > /dev/null
if [ $? -eq 1 ]; then
    echo '' >> ~/.bash_aliases
    echo '#Slicer' >> ~/.bash_aliases
    echo 'export PATH=$PATH:/usr/local/Slicer' >> ~/.bash_aliases
fi

#make icon show in the neuroimaging directory
sed -i 's/NoDisplay=true/NoDisplay=false/' ~/.local/share/applications/3dslicer.desktop

echo "Finished!"
sleep 5
exit
