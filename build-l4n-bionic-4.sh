#!/bin/bash
#Lin4Neuro making script part 4
#PinguyBuilder

#ChangeLog
#06 May 2020: Change the settings of PinguyBuilder
#29 Apr 2020: Minor custom for Pinguybuilder
#15 Feb 2019: Change from remastersys to PinguyBuilder

#Setting of path of the setting scripts
currentdir=`echo $(cd $(dirname $0) && pwd)`
base_path=$currentdir/lin4neuro-parts

#Installation of PinguyBuilder
cd ${base_path}/PinguyBuilder
sudo apt install ./pinguybuilder_5.1-8_all.deb

#replace splash.png
sudo chmod 755 /etc/PinguyBuilder
sudo find /etc/PinguyBuilder -type d -exec chmod 755 {} \;

sudo chmod 755 /usr/share/PinguyBuilder-gtk
sudo find /usr/share/PinguyBuilder-gtk -type d -exec chmod 755 {} \;

sudo chmod 755 /usr/share/doc/{PinguyBuilder,PinguyBuilder-gtk}

sudo chmod 755 /usr/lib/PinguyBuilder
sudo find /usr/lib/PinguyBuilder -type d -exec chmod 755 {} \;

sudo chmod 755 /usr/lib/python2.7/dist-packages/PinguyBuilder*

sudo chmod 755 /etc/PinguyBuilder
sudo find /etc/PinguyBuilder -type d -exec chmod 755 {} \;

sudo cp ./etc/splash.png /etc/PinguyBuilder/isolinux

# Unlink grub
if [ -e /usr/share/images/desktop-base/desktop-grub.png ]; then
  sudo unlink /usr/share/images/desktop-base/desktop-grub.png
fi

#copy config file based on locale
if [ `echo $LANG` = ja_JP.UTF-8 ]; then
    sudo cp ./etc/PinguyBuilder.conf.ja /etc/PinguyBuilder.conf
else
    sudo cp ./etc/PinguyBuilder.conf.en /etc/PinguyBuilder.conf
fi

#replace lsb_release.py
sudo cp ${base_path}/pyshared/lsb_release.py /usr/share/pyshared/

#usb-creator
sudo apt-get -y install usb-creator-common usb-creator-gtk

echo "Part 4 finished! Now ready for remastering. Execute l4n_remastering.sh"
