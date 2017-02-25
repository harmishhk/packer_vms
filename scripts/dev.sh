#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$DEV" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]]; then
    echo "==> dotfiles installation is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

UBUNTU_MAJOR_VERSION=$(lsb_release -rs | cut -f1 -d .)

# install dotfiles
echo "==> installing dotfiles" 2>&1 | tee -a $LOGFILE
git clone https://github.com/harmishhk/dotfiles /home/$SSH_USERNAME/dotfiles
source /home/$SSH_USERNAME/dotfiles/install.sh

# add fstab entry for work_vdisk, and related symlinks
echo "==> adding fstab entry for work_vdisk and symlinking" 2>&1 | tee -a $LOGFILE
sudo sh -c "echo '/dev/sdb /mnt/work_vdisk auto defaults 0 0' >> /etc/fstab"
ln -s /mnt/work_vdisk/work /home/$SSH_USERNAME/work
ln -s /home/$SSH_USERNAME/work/ros /home/$SSH_USERNAME/ros
ln -s /home/$SSH_USERNAME/work/writing /home/$SSH_USERNAME/writing

# enable user-namespace remapping in docker
echo "==> enabling user-namespace remapping for docker" 2>&1 | tee -a $LOGFILE
if [[ "$DOCKER" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]]; then
    if [[ "$UBUNTU_MAJOR_VERSION" -gt "14" ]]; then
        sudo cp /lib/systemd/system/docker.service /etc/systemd/system/
        sudo sed -i "/^ExecStart/ s/$/ --userns-remap=$SSH_USERNAME/" /etc/systemd/system/docker.service
    else
        sudo sh -c "echo 'DOCKER_OPTS=\"--userns-remap=$SSH_USERNAME\"' >> /etc/default/docker"
    fi
    sudo sed -i "s/^$SSH_USERNAME.*/$SSH_USERNAME:$(id -g):65536/" /etc/subuid
    sudo sed -i "s/^$SSH_USERNAME.*/$SSH_USERNAME:$(id -g):65536/" /etc/subgid
fi

# password less sudo-ing
echo "==> enabling password-less sudo-ing" 2>&1 | tee -a $LOGFILE
sudo mkdir -p /etc/sudoers.d
sudo touch /etc/sudoers.d/$SSH_USERNAME
sudo sh -c "echo '$SSH_USERNAME ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/$SSH_USERNAME"

# install image tools
echo "==> installing image and additional tools" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install chrony firefox geeqie gimp inkscape

# showing summary of installations
echo -e "\n\nsummary of installed tools" 2>&1
/bin/cat "$LOGFILE" 2>&1
echo -e "--------------------------\n\n" 2>&1

# workaround for networking bug with systemd
if [[ "$UBUNTU_MAJOR_VERSION" -gt "15" ]]; then
    sudo sed -i "s/timeout=[0-9]*/timeout=1/g" /lib/systemd/system/NetworkManager-wait-online.service
    sudo sed -i "/TimeoutStartSec/c\TimeoutStartSec=1sec" /lib/systemd/system/networking.service
fi
