#!/bin/bash
#Lin4Neuro making script part 4
#PinguyBuilder

#ChangeLog
#15 Feb 2019: Change from remastersys to PinguyBuilder

#Setting of path of the setting scripts
currentdir=`echo $(cd $(dirname $0) && pwd)`
base_path=$currentdir/lin4neuro-parts

#Installation of PinguyBuilder
cd ${base_path}/PinguyBuilder
sudo apt install ./pinguybuilder_5.2-1_all.deb

#replace splash.png
sudo cp ./etc/splash.png /etc/PinguyBuilder/isolinux

#copy config file based on locale
if [ `echo $LANG` = ja_JP.UTF-8 ]; then
    sudo cp ./etc/PinguyBuilder.conf.ja /etc/PinguyBuilder.conf
else
    sudo cp ./etc/PinguyBuilder.conf.en /etc/PinguyBuilder.conf
fi

#usb-creator
sudo apt-get -y install usb-creator-common usb-creator-gtk

echo "Part 4 finished! Now ready for remastering. Execute l4n_remastering.sh"
