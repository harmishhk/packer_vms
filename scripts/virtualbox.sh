#!/bin/bash -eux

if [[ ! "$GUEST_ADDITIONS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> installation of guest additions is disabled"
    exit
fi

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "==> installing VirtualBox guest additions"

    VBOX_VERSION=$(cat /home/$SSH_USERNAME/.vbox_version)
    sudo mount -o loop /home/$SSH_USERNAME/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    sudo sh /mnt/VBoxLinuxAdditions.run
    sudo umount /mnt
    rm /home/$SSH_USERNAME/VBoxGuestAdditions_$VBOX_VERSION.iso
    rm /home/$SSH_USERNAME/.vbox_version

    # make shared folders accessible
    sudo usermod -aG vboxsf $SSH_USERNAME
fi
