#!/bin/bash -eux

if [[ ! "$DEV" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> dotfiles installation is disabled"
    exit
fi

UBUNTU_MAJOR_VERSION=$(lsb_release -rs | cut -f1 -d .)

# install dotfiles
git clone https://github.com/harmishhk/dotfiles /home/$SSH_USERNAME/dotfiles
source /home/$SSH_USERNAME/dotfiles/install.sh

# add fstab entry for work_vdisk, and related symlinks
sudo sh -c "echo '/dev/sdb /mnt/work_vdisk auto defaults 0 0' >> /etc/fstab"
ln -s /mnt/work_vdisk/work /home/$SSH_USERNAME/work
ln -s /home/$SSH_USERNAME/work/ros /home/$SSH_USERNAME/ros
ln -s /home/$SSH_USERNAME/work/writing /home/$SSH_USERNAME/writing

#enable user-namespace remapping in docker
if [[ "$DOCKER" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    if [[ "$UBUNTU_MAJOR_VERSION" -gt "14" ]]; then
        sudo cp /lib/systemd/system/docker.service /etc/systemd/system/
        sudo sed -i "/^ExecStart/ s/$/ --userns-remap=$SSH_USERNAME/" /etc/systemd/system/docker.service
    else
        sudo sh -c "echo 'DOCKER_OPTS=\"--userns-remap=$SSH_USERNAME\"' >> /etc/default/docker"
    fi
    sudo sed -i "s/^$SSH_USERNAME.*/$SSH_USERNAME:$(id -g):65536/" /etc/subuid
    sudo sed -i "s/^$SSH_USERNAME.*/$SSH_USERNAME:$(id -g):65536/" /etc/subgid
fi
