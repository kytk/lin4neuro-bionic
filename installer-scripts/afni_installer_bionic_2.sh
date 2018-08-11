#!/bin/sh

#AFNI Installer part 2
#This scripts install R AFNI in /usr/local/AFNIbin

#This is based on https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/background_install/install_instructs/steps_linux_ubuntu16.html

#11 Aug 2018 K. Nemoto

cd $HOME

#Setup R
export R_LIBS=$HOME/R
mkdir $R_LIBS
echo 'export R_LIBS=$HOME/R' >> ~/.bashrc
#curl -O https://afni.nimh.nih.gov/pub/dist/src/scripts_src/@add_rcran_ubuntu.tcsh
#sudo tcsh @add_rcran_ubuntu.tcsh
rPkgsInstall -pkgs ALL

#Evaluate setup
cd $HOME
echo "Check installation"
afni_system_check.py -check_all

echo "Finished"
sleep 5
exit

