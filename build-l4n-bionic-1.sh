#!/bin/bash

#Lin4Neuro building script for Ubuntu 18.04 (Bionic)
#This script installs minimal Ubuntu with XFCE 4.12
#and Lin4Neuro theme.
#Pre-requisite: You need to install Ubuntu mini.iso and git beforehand.
#16-May-2020 K. Nemoto

#ChangeLog
#16-May-2020 add settings to .bash_aliases instead of .bashrc
#16-May-2020 add meld
#04-May-2020 drop VirtualBox settings
#22-Feb-2020 drop nemo and add rename
#28-Dec-2019 Add gddrescue
#25-Nov-2019 Add boot-repair
#25-Nov-2019 Stop using hwe kernel due to the problem with PinguyBuilder
#02-Aug-2019 Add chntpw
#22-Jul-2019 GRUB customization to show GRUB on boot
#26-Apr-2019 Add 10-globally-managed-devices.conf
#11-Mar-2019 Remove VirtualBox guest
#11-Mar-2019 change python libraries as a moudle to be installed
#10-Mar-2019 replace some parts with here document
#09-Mar-2019 minor fix
#20-Jan-2019 add pillow and alias for xdg-open
#19-Jan-2019 remove light-locker since system got unstable
#16-Jan-2019 add manpages-ja for the Japanese setting
#14-Jan-2019 add python3-tk
#11-Jan-2019 add light-locker
#01-Jan-2019 add python libraries for machine learning
#03-Dec-2018 add cups and aprurl
#28-Oct-2018 add libopenblas-base
#15-Sep-2018 add bleachbit
#14-Sep-2018 move virtualbox-related settings from part 2 to part 1
#13-Sep-2018 Delete GRUB settings 
#27-Aug-2018 add xterm
#12-Aug-2018 add baobab
#11-Aug-2018 add tcsh and update signature for Neurodebian repository
#10-Aug-2018 add ntp
#13-Jul-2018 assume that installation of mini.iso is under English locale.
#15-Apr-2018 move update LibreOffice and VirtualBox related settings to part2
#15-Apr-2018 change to use the latest kernel (hwe-18.04)
#07-Apr-2018 add linux-headers
#07-Apr-2018 add lines to /etc/fstab related to virtualbox shared folder
#30-Mar-2018 simplify customization of xfce
#28-Mar-2018 add libreoffice
#20-Mar-2018 add curl
#18-Mar-2018 Renew scripts

#(optional) Force IPv4
#Uncomment the following two lines if you want the system to use only IPv4
#echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
#echo '--inet4-only=1' >> ~/.wgetrc

LANG=C
sudo apt-get update; sudo apt-get -y upgrade

log=$(date +%Y%m%d%H%M%S)-part1.log
exec &> >(tee -a "$log")

echo "Begin making Lin4Neuro."

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

     #Setup Japanese locale
     sudo apt-get install -y language-pack-ja manpages-ja
     sudo update-locale LANG=ja_JP.UTF-8

     #Setup tzdata
     #sudo dpkg-reconfigure tzdata

     #replace us with ja in  /etc/apt/sources.list
     sudo sed -i 's|http://us.|http://ja.|g' /etc/apt/sources.list
     sudo apt-get update

     #Setup Neurodebian repository using repo in Japan
     wget -O- http://neuro.debian.net/lists/bionic.jp.full | \
     sudo tee /etc/apt/sources.list.d/neurodebian.sources.list

     break
  elif [ $lang == "English" ] ; then

     #Setup tzdata
     #sudo dpkg-reconfigure tzdata

     #Setup Neurodebian repository using in repo in us-nh
     wget -O- http://neuro.debian.net/lists/bionic.us-nh.full | \
     sudo tee /etc/apt/sources.list.d/neurodebian.sources.list

     break
  elif [ $lang == "quit" ] ; then
     echo "quit."
     exit 0
  fi
done

#Uncomment the following line to install linux-{image,headers}-generic-hwe-18.04
#sudo apt-get -y install linux-{image,headers}-generic-hwe-18.04

#Installation of XFCE 4.12
echo "Installation of XFCE 4.12"
sudo apt-get -y install xfce4 xfce4-terminal xfce4-indicator-plugin 	\
	xfce4-power-manager-plugins lightdm lightdm-gtk-greeter 	\
	shimmer-themes network-manager-gnome xinit build-essential 	\
	dkms thunar-archive-plugin file-roller gawk fonts-noto 		\
	xdg-utils 

#Installation of python-related packages
sudo apt-get -y install pkg-config libopenblas-dev liblapack-dev 	\
	libhdf5-serial-dev graphviz 
sudo apt-get -y install python3-venv python3-pip python3-dev python3-tk      


#Installation of misc packages
echo "Installation of misc packages"

sudo apt-get -y install at-spi2-core bc byobu curl wget dc	\
	default-jre evince exfat-fuse exfat-utils gedit 	\
	gnome-system-monitor gnome-system-tools gparted		\
	imagemagick rename ntp system-config-printer-gnome 	\
	system-config-samba tree unzip update-manager vim 	\
	wajig xfce4-screenshooter zip ntp tcsh baobab xterm     \
        bleachbit libopenblas-base cups apturl dmz-cursor-theme \
	chntpw gddrescue p7zip-full gnupg eog meld

#Workaround for system-config-samba
sudo touch /etc/libuser.conf

#Workaround for networking devices
sudo touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf

#vim settings
cp /usr/share/vim/vimrc ~/.vimrc
sed -i -e 's/"set background=dark/set background=dark/' ~/.vimrc

#Install firefox and libreoffice with language locale
if [ $lang == "English" ] ; then
  #English-dependent packages
  echo "Installation of firefox"
  sudo apt-get -y install firefox firefox-locale-en
  echo "Installation of libreoffice"
  sudo apt-get -y install libreoffice libreoffice-help-en

elif [ $lang == "Japanese" ] ; then
  #Japanese-dependent environment
  echo "Installation of firefox and Japanese-related packages"
  sudo apt-get -y install fcitx fcitx-mozc fcitx-config-gtk 	\
              unar nkf firefox firefox-locale-ja im-config
  echo "Installation of libreoffice"
  sudo apt-get -y install libreoffice libreoffice-l10n-ja \
	libreoffice-help-ja

  #Change name of directories to English
  LANG=C xdg-user-dirs-update --force
  im-config -n fcitx
fi

#Remove xscreensaver
sudo apt-get -y purge xscreensaver

#Installation of Lin4Neuro related settings

#Setting of path of the setting scripts
currentdir=$(cd $(dirname "$0") && pwd)
base_path=$currentdir/lin4neuro-parts

#Install plymouth-related files
sudo apt-get -y install plymouth-themes plymouth-label

#Installation of lin4neuro-logo
echo "Installation of lin4neuro-logo"
sudo cp -r "${base_path}"/lin4neuro-logo /usr/share/plymouth/themes
sudo update-alternatives --install 					\
	/usr/share/plymouth/themes/default.plymouth 			\
	default.plymouth 						\
	/usr/share/plymouth/themes/lin4neuro-logo/lin4neuro-logo.plymouth \
	100
sudo update-initramfs -u -k all

#Installation of icons
echo "Installation of icons"
mkdir -p ~/.local/share
cp -r "${base_path}"/local/share/icons ~/.local/share/

#Installation of customized menu
echo "Installation of customized menu"
mkdir -p ~/.config/menus
cp "${base_path}"/config/menus/xfce-applications.menu \
	~/.config/menus

#Installation of .desktop files
echo "Installation of .desktop files"
cp -r "${base_path}"/local/share/applications ~/.local/share/

#Installation of Neuroimaging.directory
echo "Installation of Neuroimaging.directory"
mkdir -p ~/.local/share/desktop-directories
cp "${base_path}"/local/share/desktop-directories/Neuroimaging.directory ~/.local/share/desktop-directories

#Copy background image
echo "Copy background image"
sudo cp "${base_path}"/backgrounds/deep_ocean.png /usr/share/backgrounds

#Remove an unnecessary image file
sudo rm /usr/share/backgrounds/xfce/xfce-teal.jpg

#Copy modified lightdm-gtk-greeter.conf
echo "Copy modified 01_ubuntu.conf"
sudo mkdir -p /usr/share/lightdm/lightdm-gtk-greeter.conf.d
sudo cp "${base_path}"/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf /usr/share/lightdm/lightdm-gtk-greeter.conf.d

#Settings for auto-login
echo "Settings for auto-login"
sudo mkdir -p /usr/share/lightdm/lightdm.conf.d
sudo cp "${base_path}"/lightdm/lightdm.conf.d/10-ubuntu.conf \
	/usr/share/lightdm/lightdm.conf.d

#Cusotmize of panel, dsktop, and theme
echo "Cusotmize of panel, dsktop, and theme"
cp -r "${base_path}"/config/xfce4 ~/.config

#Clean packages
sudo apt-get -y autoremove

#GRUB customization to show GRUB on boot
sudo sed -i -e 's/GRUB_TIMEOUT_STYLE/#GRUB_TIMEOUT_STYLE/' /etc/default/grub
sudo sed -i -e 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=10/' /etc/default/grub
sudo update-grub

#Boot repair
sudo add-apt-repository -y ppa:yannubuntu/boot-repair
sudo apt-get install -y boot-repair

#alias
cat << EOS >> ~/.bash_aliases

#alias for xdg-open
alias open='xdg-open &> /dev/null'

EOS


echo "Finished! The system will reboot in 10 seconds."
echo "Please run build-l4n-bionic-2.sh to install neuroimaging packages."
echo "Reboot system in 5 seconds"
sleep 5
sudo reboot

