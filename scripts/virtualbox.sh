#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$GUEST_ADDITIONS" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]]; then
    echo "==> installation of guest additions is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "==> installing VirtualBox guest additions" 2>&1 | tee -a $LOGFILE

    sudo apt-get -y install linux-headers-$(uname -r)

    VBOX_VERSION=$(cat /home/$SSH_USERNAME/.vbox_version)
    sudo mount -o loop /home/$SSH_USERNAME/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    sudo sh /mnt/VBoxLinuxAdditions.run
    sudo umount /mnt
    rm /home/$SSH_USERNAME/VBoxGuestAdditions_$VBOX_VERSION.iso
    rm /home/$SSH_USERNAME/.vbox_version

    #sudo apt-get -y install virtualbox-guest-x11

    # make shared folders accessible
    sudo usermod -aG vboxsf $SSH_USERNAME
fi
