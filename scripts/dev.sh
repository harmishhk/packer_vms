#!/bin/bash -eux

if [[ ! "$DEV" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> dotfiles installation is disabled"
    exit
fi

# install dotfiles
git clone https://github.com/harmishhk/dotfiles /home/$SSH_USERNAME/dotfiles
source /home/$SSH_USERNAME/dotfiles/install.sh

# make work directory
mkdir /home/$SSH_USERNAME/work
ln -s /home/$SSH_USERNAME/work/ros /home/$SSH_USERNAME/ros

# add fstab entry
sudo sh -c "echo '/dev/sdb /mnt/work_vdisk auto defaults 0 0' >> /etc/fstab"
ln -s /mnt/work_vdisk/work /home/$SSH_USERNAME/work

if [[ "$DOCKER" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    # chagne storage location for docker images
    sudo sh -c "echo '/dev/sdc /mnt/docker_vdisk auto defaults 0 0' >> /etc/fstab"
    ln -s /mnt/docker_vdisk/docker-graph /home/$SSH_USERNAME/.docker-graph
    sudo sh -c "echo 'DOCKER_OPTS=\"-g /home/$SSH_USERNAME/.docker-graph\"' >> /etc/default/docker"
fi
