#!/bin/bash

#Virtualbox settings
#Install VirtualBox Guest Addition first 

sudo usermod -aG vboxsf $(whoami)

#fstab
echo '' | sudo tee -a /etc/fstab
echo '#Virtualbox shared folder' | sudo tee -a /etc/fstab
echo 'share /media/sf_share vboxsf _netdev,uid=1000,gid=1000 0 0' | sudo tee -a /etc/fstab

echo "Done. Please reboot the system to reflect the settings"

exit

