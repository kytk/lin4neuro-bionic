#!/bin/sh

#AFNI Installer part 2
#This scripts install R AFNI in /usr/local/AFNIbin

#This is basically based on https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/background_install/install_instructs/steps_linux_ubuntu16.html

#18 Aug 2018 K. Nemoto

cd $HOME

#SUMA setup
suma -update_env

#Install help
apsearch -update_all_afni_help

#Setup R
export R_LIBS=$HOME/R

if [ ! -e ~/R ]; then
    mkdir $R_LIBS
else
    echo "$R_LIBS already exists."
fi

grep R_LIBS ~/.bashrc > /dev/null
if [ $? -eq 1 ]; then
    echo '' >> ~/.bashrc
    echo '#R for AFNI' >> ~/.bashrc
    echo 'export R_LIBS=$HOME/R' >> ~/.bashrc
fi

#Install new R, removing any old one first.
sudo apt-get remove -y r-base r-base-core r-base-dev
sudo apt-get update
sudo apt-get install -y r-base-dev r-cran-rmpi

#Install rPkgs
rPkgsInstall -pkgs ALL

#Install matplotlib (python2)
sudo apt-get install -y python-matplotlib

#Evaluate setup
cd $HOME
echo "Check installation"
afni_system_check.py -check_all

echo "Finished"
sleep 5
exit

