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
sudo sh -c "echo '/dev/sdb /home/$SSH_USERNAME/work auto defaults 0 0' >> /etc/fstab"

if [[ "$DOCKER" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    # chagne storage location for docker images
    mkdir /home/$SSH_USERNAME/.docker-graph
    sudo sh -c "echo 'DOCKER_OPTS=\"-g /home/$SSH_USERNAME/.docker-graph\"' >> /etc/default/docker"
    sudo sh -c "echo '/dev/sdc /home/$SSH_USERNAME/.docker-graph auto defaults 0 0' >> /etc/fstab"
fi
