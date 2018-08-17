#!/bin/sh

#AFNI Installer
#This scripts install AFNI in /usr/local/AFNIbin

#This is based on https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/background_install/install_instructs/steps_linux_ubuntu16.html

#11 Aug 2018 K. Nemoto

#Install prerequisite packages
sudo apt update
sudo apt install -y tcsh xfonts-base python-qt4       \
                   gsl-bin netpbm gnome-tweak-tool    \
                   libjpeg62 xvfb xterm vim curl

sudo apt install -y libglu1-mesa-dev libglw1-mesa     \
                    libxm4 build-essential

#Download AFNI binary and installer
cd $HOME/Downloads

#curl -O https://afni.nimh.nih.gov/pub/dist/tgz/linux_ubuntu_16_64.tgz
curl -O https://afni.nimh.nih.gov/pub/dist/bin/linux_ubuntu_16_64/@update.afni.binaries

#Install to /usr/local/AFNIbin
sudo tcsh @update.afni.binaries -curl -package linux_ubuntu_16_64 -bindir /usr/local/AFNIbin -do_extras

cd $HOME

#.bashrc
echo ' ' >> ~/.bashrc
echo '#AFNI' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/AFNIbin' >> ~/.bashrc

#Make AFNI/SUMA profiles
cp /usr/local/AFNIbin/AFNI.afnirc $HOME/.afnirc
suma -update_env

#Install help
apsearch -update_all_afni_help

cat << EOS >> ~/.bashrc

ahdir=`apsearch -afni_help_dir`
if [ -f "$ahdir/all_progs.COMP.bash" ]
then
   . $ahdir/all_progs.COMP.bash
fi
EOS

#make icon show in the neuroimaging directory
sed -i 's/NoDisplay=true/NoDisplay=false/' ~/.local/share/applications/afni.desktop

#Reboot
echo "Installation finished. Please reboot the system"
sleep 5
exit

