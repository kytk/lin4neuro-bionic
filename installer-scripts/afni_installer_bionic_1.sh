#!/bin/sh

#AFNI Installer
#This scripts install AFNI in /usr/local/AFNIbin

#This is basically based on https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/background_install/install_instructs/steps_linux_ubuntu16.html

#18 Aug 2018 K. Nemoto

#Install prerequisite packages
sudo apt update
sudo apt-get install -y tcsh xfonts-base python-qt4       \
                       gsl-bin netpbm gnome-tweak-tool    \
                       libjpeg62 xvfb xterm vim curl

sudo apt-get install -y libglu1-mesa-dev libglw1-mesa     \
                       libxm4 build-essential

#Install necessary packages especially for Ubuntu 18.04
sudo apt-get install -y libcurl4-openssl-dev libxml2-dev  \
                       libssl-dev libgfortran3

#make a symbolic link for libgsl.so for Ubuntu 18.04
sudo ln -s /usr/lib/x86_64-linux-gnu/libgsl.so.23 /usr/lib/x86_64-linux-gnu/libgsl.so.19

#Download AFNI binary and installer
cd $HOME/Downloads

#curl -O https://afni.nimh.nih.gov/pub/dist/tgz/linux_ubuntu_16_64.tgz
curl -O https://afni.nimh.nih.gov/pub/dist/bin/linux_ubuntu_16_64/@update.afni.binaries

#Install to /usr/local/AFNIbin
sudo tcsh @update.afni.binaries -curl -package linux_ubuntu_16_64 -bindir /usr/local/AFNIbin -do_extras

cd $HOME

#.bash_aliases
grep AFNI ~/.bash_aliases > /dev/null
if [ $? -eq 1 ]; then
    echo ' ' >> ~/.bash_aliases
    echo '#AFNI' >> ~/.bash_aliases
    echo 'export PATH=$PATH:/usr/local/AFNIbin' >> ~/.bash_aliases
fi

source ~/.bash_aliases

#Make AFNI/SUMA profiles
cp /usr/local/AFNIbin/AFNI.afnirc $HOME/.afnirc

grep ahdir ~/.bash_aliases > /dev/null
if [ $? -eq 1 ]; then
  echo 'ahdir=$(apsearch -afni_help_dir)' >> ~/.bash_aliases
  echo 'if [ -f "$ahdir/all_progs.COMP.bash" ]; then' >> ~/.bash_aliases
  echo '  . $ahdir/all_progs.COMP.bash' >> ~/.bash_aliases
  echo 'fi' >> ~/.bash_aliases
fi

#make icon show in the neuroimaging directory
sed -i 's/NoDisplay=true/NoDisplay=false/' ~/.local/share/applications/afni.desktop

#Reboot
echo "Installation finished. Please reboot the system"
sleep 5
exit

