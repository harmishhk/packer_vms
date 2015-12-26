#!/bin/bash -eux

echo "==> disabling the release upgrader"
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

if [[ ! "$UPDATE" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> updating is disabled"
    exit
fi

echo "==> performing dist-upgrade (all packages and kernel)"
    apt-get -y update
#    apt-get -y dist-upgrade --force-yes
    apt-get -y dist-upgrade
    reboot
    sleep 60
fi
