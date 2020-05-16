#!/bin/bash
#CONN18a standalone installer

#Check MCR is installed
if [ ! -d /usr/local/MATLAB/MCR/v92 ]; then
  echo "Matlab Compiler Runtime needs to be installed first!"
  ~/git/lin4neuro-bionic/installer-scripts/mcr_v92_installer_bionic.sh
fi

#Download CONN18a standalone
echo "Download CONN18a standalone"
cd $HOME/Downloads

if [ ! -e 'conn18a_glnxa64.zip' ]; then
  curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/conn18a_glnxa64.zip
fi

cd /usr/local
sudo unzip ~/Downloads/conn18a_glnxa64.zip

sed -i 's/NoDisplay=true/NoDisplay=false/' ~/.local/share/applications/conn.desktop

#alias
echo '' >> ~/.bash_aliases
echo '#conn18a standalone' >> ~/.bash_aliases
echo "alias conn='/usr/local/conn_standalone/R2017a/run_conn.sh /usr/local/MATLAB/MCR/v92'" >> ~/.bash_aliases


echo "Finished! Run CONN from menu -> Neuroimaging -> CONN"
sleep 5 
exit

