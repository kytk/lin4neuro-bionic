#!/bin/bash
#CONN18b standalone installer

#Check MCR is installed
if [ ! -d /usr/local/MATLAB/MCR/v95 ]; then
  echo "Matlab Compiler Runtime needs to be installed first!"
  ~/git/lin4neuro-bionic/installer-scripts/mcr_v95_installer_bionic.sh
fi

#Download CONN18b standalone
echo "Download CONN18b standalone"
cd $HOME/Downloads

if [ ! -e 'conn18b_glnxa64.zip' ]; then
  curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/conn18b_glnxa64.zip
fi

cd /usr/local
sudo mkdir conn18b_standalone
cd conn18b_standalone
sudo unzip ~/Downloads/conn18b_glnxa64.zip

sed -i 's/NoDisplay=true/NoDisplay=false/' ~/.local/share/applications/conn18b.desktop

#alias
echo '' >> ~/.bash_aliases
echo '#conn18b standalone' >> ~/.bash_aliases
echo "alias conn='/usr/local/conn18b_standalone/run_conn.sh /usr/local/MATLAB/MCR/v95'" >> ~/.bash_aliases


echo "Finished! Run CONN from menu -> Neuroimaging -> CONN"
sleep 5 
exit

