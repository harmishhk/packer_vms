#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

echo "==> disabling the release upgrader" 2>&1 | tee -a $LOGFILE
sudo sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

if [[ ! "$UPDATE" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]]; then
    echo "==> updating is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

echo "==> performing dist-upgrade (all packages and kernel)" 2>&1 | tee -a $LOGFILE
sudo apt-get update
# apt-get -y dist-upgrade --force-yes
sudo apt-get -y dist-upgrade
sudo reboot
sleep 60
