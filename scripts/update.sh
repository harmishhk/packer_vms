#!/bin/bash -eux

echo "==> disabling the release upgrader"
sudo sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

if [[ ! "$UPDATE" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> updating is disabled"
    exit
fi

echo "==> performing dist-upgrade (all packages and kernel)"
    sudo apt-get -y update
#    apt-get -y dist-upgrade --force-yes
    sudo apt-get -y dist-upgrade
    sudo reboot
    sleep 60
fi
