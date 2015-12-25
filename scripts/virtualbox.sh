#!/bin/bash -eux

if [[ ! "$GUEST_ADDITIONS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> installation of guest additions is disabled"
    exit
fi

SSH_USER=${SSH_USERNAME:-ubuntu}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "==> installing VirtualBox guest additions"

    VBOX_VERSION=$(cat /home/${SSH_USER}/.vbox_version)
    mount -o loop /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso
    rm /home/${SSH_USER}/.vbox_version

    if [[ $VBOX_VERSION = "4.3.10" ]]; then
        ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    fi
fi
