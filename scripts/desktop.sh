#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$DESKTOP" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]]; then
    echo "==> ubuntu-desktop installation is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

echo "==> installing ubunutu-desktop (this may take a long time)" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install ubuntu-desktop

echo "==> setting-up automatic login" 2>&1 | tee -a $LOGFILE
LIGHTDM_CUSTOM_CONF=/etc/lightdm/lightdm.conf
sudo mkdir -p $(dirname $LIGHTDM_CUSTOM_CONF)
sudo sh -c "echo '[SeatDefaults]' >> $LIGHTDM_CUSTOM_CONF"
sudo sh -c "echo 'autologin-user=$SSH_USERNAME' >> $LIGHTDM_CUSTOM_CONF"

# GDM_CUSTOM_CONFIG=/etc/gdm/custom.conf
# sudo mkdir -p $(dirname $GDM_CUSTOM_CONFIG)
# sudo sh -c "echo '[daemon]' >> $GDM_CUSTOM_CONFIG"
# sudo sh -c "echo '# enabling automatic login' >> $GDM_CUSTOM_CONFIG"
# sudo sh -c "echo 'AutomaticLoginEnable=True' >> $GDM_CUSTOM_CONFIG"
# sudo sh -c "echo 'AutomaticLoginEnable=$SSH_USERNAME' >> $GDM_CUSTOM_CONFIG"
