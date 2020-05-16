#!/bin/bash

#Lin4Neuro ISO building script for Ubuntu 18.04 (Bionic) using cubic
#copy this script to terminal in cubic and run

#ChangeLog
#16-May-2020 created this script

echo "Which language do you want to build? (English/Japanese)"
select lang in "English" "Japanese" "quit"
do
  if [ "$REPLY" = "q" ] ; then
     echo "quit."
     exit 0
  fi
  if [ -z "$lang" ] ; then
     continue
  elif [ $lang == "Japanese" ] ; then
     la=ja
     break
  elif [ $lang == "English" ] ; then
     la=us
     break
  elif [ $lang == "quit" ] ; then
     echo "quit."
     exit 0
  fi
done

rm /etc/apt/sources.list
cat << EOF >> /etc/apt/sources.list
deb http://archive.ubuntu.com/ubuntu/ bionic main restricted
deb http://archive.ubuntu.com/ubuntu/ bionic-updates main restricted
deb http://archive.ubuntu.com/ubuntu/ bionic universe
deb http://archive.ubuntu.com/ubuntu/ bionic-updates universe
deb http://archive.ubuntu.com/ubuntu/ bionic multiverse
deb http://archive.ubuntu.com/ubuntu/ bionic-updates multiverse
deb http://archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu bionic-security main restricted
deb http://security.ubuntu.com/ubuntu bionic-security universe
deb http://security.ubuntu.com/ubuntu bionic-security multiverse
EOF

apt-get update

#Installation of XFCE 4.12
apt-get -y install xfce4 xfce4-terminal xfce4-indicator-plugin 	\
	xfce4-power-manager-plugins lightdm lightdm-gtk-greeter 	\
	shimmer-themes network-manager-gnome xinit build-essential 	\
	dkms thunar-archive-plugin file-roller gawk fonts-noto 		\
	xdg-utils 

apt-get -y install pkg-config libopenblas-dev liblapack-dev		\
	libhdf5-serial-dev graphviz python3-venv python3-pip 		\
	python3-dev python3-tk      

#Installation of misc packages
apt-get -y install at-spi2-core bc byobu curl wget dc 		\
	default-jre evince exfat-fuse exfat-utils gedit 	\
	gnome-system-monitor gnome-system-tools gparted		\
	imagemagick rename ntp system-config-printer-gnome 	\
	system-config-samba tree unzip update-manager vim 	\
	wajig xfce4-screenshooter zip ntp tcsh baobab xterm     \
        bleachbit libopenblas-base cups apturl dmz-cursor-theme \
	chntpw gddrescue p7zip-full git eog meld

#Workaround for system-config-samba
touch /etc/libuser.conf

#Workaround for networking devices
touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf

#vim settings
cp /usr/share/vim/vimrc /etc/skel/.vimrc
sed -i -e 's/"set background=dark/set background=dark/' /etc/skel/.vimrc

#Remove xscreensaver
apt-get -y purge xscreensaver

###Language-dependent settings###
if [ $la == "us" ]; then
  #neurodebian
  wget -O- http://neuro.debian.net/lists/bionic.us-nh.full | \
  tee /etc/apt/sources.list.d/neurodebian.sources.list

  #Install firefox and libreoffice
  apt-get -y install firefox firefox-locale-en 
  apt-get -y install libreoffice libreoffice-help-en

elif [ $la == "ja" ]; then
  #neurodebian
  wget -O- http://neuro.debian.net/lists/bionic.jp.full | \
  tee /etc/apt/sources.list.d/neurodebian.sources.list

  #Install fcitx, firefox and libreoffice
  apt-get -y install fcitx fcitx-mozc fcitx-config-gtk 	\
           unar nkf firefox firefox-locale-ja im-config
  apt-get -y install libreoffice libreoffice-l10n-ja \
	libreoffice-help-ja
fi


#Installation of Lin4Neuro related settings

#Setting of path of the setting scripts
currentdir=$(cd $(dirname "$0") && pwd)
base_path=$currentdir/lin4neuro-parts

#Install plymouth-related files
apt-get -y install plymouth-themes plymouth

#Installation of lin4neuro-logo
cp -r "${base_path}"/lin4neuro-logo /usr/share/plymouth/themes
update-alternatives --install 					\
	/usr/share/plymouth/themes/default.plymouth 			\
	default.plymouth 						\
	/usr/share/plymouth/themes/lin4neuro-logo/lin4neuro-logo.plymouth \
	100
update-alternatives --config default.plymouth
update-initramfs -u 

#Installation of icons
mkdir -p /etc/skel/.local/share
cp -r "${base_path}"/local/share/icons /etc/skel/.local/share/

#Installation of customized menu
mkdir -p /etc/skel/.config/menus
cp "${base_path}"/config/menus/xfce-applications.menu \
	/etc/skel/.config/menus

#Installation of .desktop files
echo "Installation of .desktop files"
cp -r "${base_path}"/local/share/applications /etc/skel/.local/share/

#Installation of Neuroimaging.directory
echo "Installation of Neuroimaging.directory"
mkdir -p /etc/skel/.local/share/desktop-directories
cp "${base_path}"/local/share/desktop-directories/Neuroimaging.directory /etc/skel/.local/share/desktop-directories

#Copy background image
echo "Copy background image"
cp "${base_path}"/backgrounds/deep_ocean.png /usr/share/backgrounds

#Remove an unnecessary image file
rm /usr/share/backgrounds/xfce/xfce-teal.jpg

#Copy modified lightdm-gtk-greeter.conf
echo "Copy modified 01_ubuntu.conf"
mkdir -p /usr/share/lightdm/lightdm-gtk-greeter.conf.d
cp "${base_path}"/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf /usr/share/lightdm/lightdm-gtk-greeter.conf.d

#Settings for auto-login
echo "Settings for auto-login"
mkdir -p /usr/share/lightdm/lightdm.conf.d
cp "${base_path}"/lightdm/lightdm.conf.d/10-ubuntu.conf \
	/usr/share/lightdm/lightdm.conf.d

#Cusotmize of panel, dsktop, and theme
echo "Cusotmize of panel, dsktop, and theme"
cp -r "${base_path}"/config/xfce4 /etc/skel/.config

#Copy lin4neuro-bionic
mkdir /etc/skel/git
cp -r ../lin4neuro-bionic /etc/skel/git/

#Delete ubuntu-desktop
apt-get purge -y nautilus gnome-power-manager gnome-screensaver gnome-termina* \
  gnome-pane* gnome-applet* gnome-bluetooth gnome-desktop* gnome-sessio* \
  gnome-user* gnome-shell-common compiz compiz* unity unity* hud zeitgeist \
  zeitgeist* python-zeitgeist libzeitgeist* activity-log-manager-common \
  gnome-control-center gnome-screenshot overlay-scrollba* 
 
#Clean packages
apt-get -y autoremove

#Remove unnecessary configuration files
dpkg -l | awk '/^rc/ {print $2}' | xargs dpkg --purge

#alias
cat << EOS >> /etc/skel/.bash_aliases

#alias for xdg-open
alias open='xdg-open &> /dev/null'

EOS

#Post-installation script
cat << 'EOS' >> /etc/skel/.profile

#Post installation script
if [ $(id -u) -ne 999 ]; then 
  if [ ! -d /usr/local/MRIcroGL ]; then
      cd ~/git/lin4neuro-bionic
      xfce4-terminal -x './build-l4n-bionic-2.sh' &
  fi
fi

cd $HOME 

EOS

echo "Done."
exit

