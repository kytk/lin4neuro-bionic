#!/bin/bash
#Lin4Neuro making script part 4
#PinguyBuilder

#ChangeLog
#04 May 2020: Rollback PinguyBuilder from 5.2-1 to 5.1-8
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
sudo chmod 755 /etc/PinguyBuilder/{gdm3,icons,isolinux,mdm,plymouth,preseed,scripts}
sudo cp ./etc/splash.png /etc/PinguyBuilder/isolinux

# Unlink grub
sudo unlink /usr/share/images/desktop-base/desktop-grub.png

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
