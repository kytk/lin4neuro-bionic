#!/bin/bash
#freesurfer_7.1.0_installer.sh
#Script to install freesurfer v7.1.0
#This script downloads required files, install them, and configure that
#subject directory is under $HOME

#16-May-2020 K. Nemoto

#Changelog
#16-May-2020 change path to allow co-existence of V6 and V7

echo "Begin installation of FreeSurfer"
echo
echo "This script will download and install Freesurfer in Ubuntu 18.04"
echo "You need to prepare license.txt beforehand."
echo "license.txt should be placed in $HOME/Downloads"

ver=7.1.0

while true; do

echo "Are you sure you want to begin the installation of FreeSurfer? (yes/no)"
read answer 
    case $answer in
        [Yy]*)
          echo "Begin installation."
	  break
          ;;
        [Nn]*)
          echo "Abort installation."
          exit 1
          ;;
        *)
          echo -e "Please type yes or no. \n"
          ;;
    esac
done

#Check if one wants to modify recon-all for VirtualBox environment
while true; do
echo "Do you want to modify recon-all for VirtualBox environment? (yes/no)"
read answer
    case $answer in
        [Yy]*)
          echo "modify recon-all later."
          reconallvb=1
          break
          ;;
        [Nn]*)
          echo "will not modify recon-all."
          break
          ;;
        *)
          echo -e "Please type yes or no. \n"
          ;;
    esac
done

echo "Check if you have license.txt in $HOME/Downloads"

if [ -e $HOME/Downloads/license.txt ]; then
    echo "license.txt exists. Continue installation."
else
    echo "You need to prepare license.txt"
    echo "Abort installation. Please run the script after you put license.txt in $HOME/Downloads"
    exit 1
fi

cd $HOME/Downloads

# install libjpeg62
libjpeg62_indicator=$(dpkg -l | grep libjpeg62 | cut -c 1-2)
if [ "$libjpeg62_indicator" != "ii" ]; then
  echo "install libjpeg62"
  curl -O http://security.ubuntu.com/ubuntu/pool/universe/libj/libjpeg6b/libjpeg62_6b2-3_amd64.deb
  sudo apt install -y ./libjpeg62_6b2-3_amd64.deb
fi

# install libpng12
libpng12_indicator=$(dpkg -l | grep libpng12 | cut -c 1-2)
if [ "$libpng12_indicator" != "ii" ]; then
  echo "install libpng12"
  curl -O http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
  sudo apt install -y ./libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
fi

# download freesurfer
if [ ! -e $HOME/Downloads/freesurfer-linux-centos7_x86_64-7.1.0.tar.gz ]; then
	echo "Download Freesurfer to $HOME/Downloads"
	cd $HOME/Downloads
	curl -O -C - ftp://ftp.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.1.0/freesurfer-linux-centos7_x86_64-7.1.0.tar.gz
else
	echo "Freesurfer archive is found in $HOME/Downloads"
fi

# check the archive
cd $HOME/Downloads
echo "Check if the downloaded archive is not corrupt."
echo "bdd5df1246df05b6d87ef7be1588ad0a  freesurfer-linux-centos7_x86_64-7.1.0.tar.gz" > freesurfer-linux-centos7_x86_64-7.1.0.tar.gz.md5

md5sum -c freesurfer-linux-centos7_x86_64-7.1.0.tar.gz.md5
while [ "$?" -ne 0 ]; do
    echo "Filesize is not correct. Re-try downloading."
    curl -O -C - ftp://ftp.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.1.0/freesurfer-linux-centos7_x86_64-7.1.0.tar.gz
    md5sum -c freesurfer-linux-centos7_x86_64-7.1.0.tar.gz.md5
done

echo "Filesize is correct!"
rm freesurfer-linux-centos7_x86_64-7.1.0.tar.gz.md5

# install freesurfer
echo "Install freesurfer"
if [ ! -d /usr/local/freesurfer ]; then
  sudo mkdir /usr/local/freesurfer
fi

cd /usr/local/freesurfer/
sudo tar xvzf $HOME/Downloads/freesurfer-linux-centos7_x86_64-7.1.0.tar.gz
sudo mv freesurfer $ver

if [ -d "/usr/local/freesurfer/$ver" ]; then
    sudo cp $HOME/Downloads/license.txt /usr/local/freesurfer/$ver
else
    echo "freesurfer is not extracted correctly."
    exit 1
fi

# prepare freesurfer directory in $HOME
echo "make freesurfer directory in $HOME"
cd $HOME
if [ ! -d freesurfer ]; then
    mkdir freesurfer
fi

cp -r /usr/local/freesurfer/$ver/subjects $HOME/freesurfer

# append to .bash_aliases
if [ -f $HOME/.bash_aliases ]; then
  grep freesurfer/$ver $HOME/.bash_aliases > /dev/null
  if [ "$?" -eq 0 ]; then
    echo ".bash_aliases is already set."
  else
    echo >> $HOME/.bash_aliases
    echo "#FreeSurfer $ver" >> $HOME/.bash_aliases
    echo "export SUBJECTS_DIR=~/freesurfer/subjects" >> $HOME/.bash_aliases
    echo "export FREESURFER_HOME=/usr/local/freesurfer/$ver" >> $HOME/.bash_aliases
    echo 'source $FREESURFER_HOME/SetUpFreeSurfer.sh' >> $HOME/.bash_aliases
  fi
fi

# replace 'ln -s' and 'ln -sf' with 'cp' in recon-all, trac-preproc, gcaprepone, and make_average_{subject,surface,volume} for virtualbox environment
if [ "$reconallvb" == 1 ]; then
  sudo sed -i 's/ln -sf/cp/' /usr/local/freesurfer/$ver/bin/recon-all
  sudo sed -i 's/ln -s \$hemi/cp \$hemi/' /usr/local/freesurfer/$ver/bin/recon-all
  sudo sed -i 's/ln -s \$FREESURFER_HOME\/subjects\/fsaverage/cp -r \$FREESURFER_HOME\/subjects\/fsaverage \$SUBJECTS_DIR/' /usr/local/freesurfer/$ver/bin/recon-all
  sudo sed -i 's/ln -s \$FREESURFER_HOME\/subjects\/\${hemi}.EC_average/cp -r \$FREESURFER_HOME\/subjects\/\${hemi}.EC_average \$SUBJECTS_DIR/' /usr/local/freesurfer/$ver/bin/recon-all
  sudo sed -i 's/ln -sfn/cp/' /usr/local/freesurfer/$ver/bin/trac-preproc
  sudo sed -i 's/ln -sf/cp/' /usr/local/freesurfer/$ver/bin/trac-preproc
  sudo sed -i 's/ln -s/cp/' /usr/local/freesurfer/$ver/bin/trac-preproc
  sudo sed -i 's/ln -s/cp/' /usr/local/freesurfer/$ver/bin/gcaprepone
  sudo sed -i 's/ln -s/cp/' /usr/local/freesurfer/$ver/bin/make_average_subject
  sudo sed -i 's/ln -s/cp/' /usr/local/freesurfer/$ver/bin/make_average_surface
  sudo sed -i 's/ln -s/cp/' /usr/local/freesurfer/$ver/bin/make_average_volume
fi

echo "Installation finished!"
echo "Now close this terminal, open another terminal, then run freeview."

exit

