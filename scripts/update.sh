#!/bin/bash -eux

echo "==> disabling the release upgrader"
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

echo "==> updating list of repositories"
apt-get -y update

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    echo "==> performing dist-upgrade (all packages and kernel)"
    apt-get -y dist-upgrade --force-yes
    reboot
    sleep 60
fi
