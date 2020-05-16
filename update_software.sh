#!/bin/bash
#Update neuroimaging-related software packages installed by build-2 script


#Log
log=$(date +%Y%m%d%H%M%S)-update.log
exec &> >(tee -a "$log")


#Aliza
echo "Install Aliza"
cd "$HOME"/Downloads

if [ ! -e 'aliza_1.98.17.1.deb' ]; then
  curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/aliza_1.98.17.1.deb
fi

sudo apt install -y ./aliza_1.98.17.1.deb


#c3d
echo "Install c3d"
sudo rm -rf /usr/local/c3d

cd "$HOME"/Downloads

if [ ! -e 'c3d-1.0.0-Linux-x86_64.tar.gz' ]; then
  curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/c3d-1.0.0-Linux-x86_64.tar.gz
fi

cd /usr/local
sudo tar xvzf ~/Downloads/c3d-1.0.0-Linux-x86_64.tar.gz
sudo mv c3d-1.0.0-Linux-x86_64 c3d

grep c3d ~/.bash_aliases > /dev/null
if [ $? -eq 1 ]; then
    echo '' >> ~/.bash_aliases
    echo '#c3d' >> ~/.bash_aliases
    echo 'export PATH=$PATH:/usr/local/c3d/bin' >> ~/.bash_aliases
    echo 'source $HOME/bin/bashcomp.sh' >> ~/.bash_aliases
fi

#itksnap
echo "Install ITK-SNAP"

sudo rm -rf /usr/local/itksnap

cd "$HOME"/Downloads

if [ ! -e 'itksnap-3.8.0-20190612-Linux-x86_64.tar.gz' ]; then
  curl -O  http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/itksnap-3.8.0-20190612-Linux-x86_64.tar.gz
fi

cd /usr/local
sudo tar xvzf ~/Downloads/itksnap-3.8.0-20190612-Linux-x86_64.tar.gz
sudo mv itksnap-3.8.0-20190612-Linux-gcc64 itksnap

# install libpng12
echo "install libpng12"
cd $HOME/Downloads
curl -O http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
sudo apt install -y ./libpng12-0_1.2.54-1ubuntu1.1_amd64.deb

grep itksnap ~/.bash_aliases > /dev/null
if [ $? -eq 1 ]; then
    echo '' >> ~/.bash_aliases
    echo '#ITK-SNAP' >> ~/.bash_aliases
    echo 'export PATH=$PATH:/usr/local/itksnap/bin' >> ~/.bash_aliases
fi

#Mango
echo "Install Mango"
sudo rm -rf /usr/local/Mango
cd "$HOME"/Downloads

if [ -e 'mango_unix.zip' ]; then
  rm mango_unix.zip
fi
curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/mango_unix.zip

cd /usr/local
sudo unzip ~/Downloads/mango_unix.zip

#MRIcron
echo "Install MRIcron"
cd "$HOME"/Downloads

if [ -e 'lx.zip' ]; then
  rm lx.zip
fi
curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/lx.zip


cd /usr/local
sudo rm -rf mricron
sudo unzip ~/Downloads/lx.zip
sudo mv mricron_lx mricron
cd mricron
sudo find lut -type f -exec chmod 644 {} \;
sudo find templates -type f -exec chmod 644 {} \;

grep mricron ~/.bash_aliases > /dev/null
if [ $? -eq 1 ]; then
    echo '' >> ~/.bash_aliases
    echo '#MRIcron' >> ~/.bash_aliases
    echo 'export PATH=$PATH:/usr/local/mricron' >> ~/.bash_aliases
fi

#MRIcroGL
echo "Install MRIcroGL"
cd "$HOME"/Downloads

if [ -e MRIcroGL_linux.zip ]; then
  rm MRIcroGL_linux.zip
fi

curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/MRIcroGL_linux.zip

cd /usr/local
sudo rm -rf MRIcroGL
sudo unzip ~/Downloads/MRIcroGL_linux.zip

grep MRIcroGL ~/.bash_aliases > /dev/null
if [ $? -eq 1 ]; then
    echo '' >> ~/.bash_aliases
    echo '#MRIcroGL' >> ~/.bash_aliases
    echo 'export PATH=$PATH:/usr/local/MRIcroGL' >> ~/.bash_aliases
    echo 'export PATH=$PATH:/usr/local/MRIcroGL/Resources' >> ~/.bash_aliases
fi

#tutorial
echo "Install tutorial by Chris Rorden"
cd "$HOME"/Downloads

if [ -e 'tutorial.zip' ]; then
  rm tutorial.zip
fi
curl -O http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/tutorial.zip

cd "$HOME"
rm -rf tutorial
unzip ~/Downloads/tutorial.zip

#Remove MacOS hidden files
find "$HOME" -name '__MACOSX' -exec rm -rf {} \;
find "$HOME" -name '.DS_Store' -exec rm -rf {} \;
#sudo find /usr/local -name '__MACOSX' -exec sudo rm -rf {} \;
#sudo find /usr/local -name '.DS_Store' -exec sudo rm -rf {} \;

#packages to be installed by users (with installer)
#ANTs
#CONN
#FSL
#Slicer
#SPM12

#Add the symbolic link to the installer to ~/.profile
cat << EOS >> ~/.profile

#symbolic links
if [ ! -L ~/Desktop/installer ]; then
   ln -fs ~/git/lin4neuro-bionic/installer ~/Desktop
fi

EOS

# change symbolic link of /bin/sh from dash to bash
echo "dash dash/sh boolean false" | sudo debconf-set-selections
sudo dpkg-reconfigure --frontend=noninteractive dash

echo "Finished!"

exit

