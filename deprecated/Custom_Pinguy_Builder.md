# Customization of Pinguy Builder

## Change splash
copy customized splash.png to /etc/PinguyBuilder/isolinux

## Config file
lin4neuro-parts/PinguyBuilder/etc/PinguyBuilder.conf.{en,ja}

## Modify /usr/share/pyshared/lsb_release.py

RELEASES_ORDER.sort(key=lambda n: float(n[0]))
->
RELEASES_ORDER.sort(key=lambda n: float(n[0].split()[0]))

# Unlink grub
sudo unlink /usr/share/images/desktop-base/desktop-grub.png

