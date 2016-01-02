#!/bin/bash -eux

if [[ ! "$DESKTOP" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> ubuntu-desktop installation is disabled"
    exit
fi

echo "==> installing ubunutu-desktop (this may take a long time)"
sudo apt-get -y -qq install ubuntu-desktop

echo "==> setting-up automatic login"
sudo mkdir -p /etc/lightdm
sudo sh -c "echo '[SeatDefaults]' >> /etc/lightdm/lightdm.conf"
sudo sh -c "echo 'autologin-user=$SSH_USERNAME' >> /etc/lightdm/lightdm.conf"

# GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf
# sudo mkdir -p $(dirname $GDM_CUSTOM_CONFIG)
# sudo sh -c "echo '[daemon]' >> $GDM_CUSTOM_CONFIG"
# sudo sh -c "echo '# enabling automatic login' >> $GDM_CUSTOM_CONFIG"
# sudo sh -c "echo 'AutomaticLoginEnable=True' >> $GDM_CUSTOM_CONFIG"
# sudo sh -c "echo 'AutomaticLoginEnable=$SSH_USERNAME' >> $GDM_CUSTOM_CONFIG"
