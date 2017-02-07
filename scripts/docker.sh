#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$DOCKER" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]]; then
    echo "==> docker installation is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

UBUNTU_VERSION=$(lsb_release -rs)
UBUNTU_MAJOR_VERSION=$(lsb_release -rs | cut -f1 -d .)

# install docker prerequisites, add docker key and repository
sudo apt-get update
if [[ "$UBUNTU_VERSION" =~ ^("14.04"|"16.04")$ ]]; then
    echo "==> installing docker prerequisites" 2>&1 | tee -a $LOGFILE
    sudo apt-get -y install apt-transport-https ca-certificates curl linux-image-extra-$(uname -r) linux-image-extra-virtual
    curl -fsSL https://yum.dockerproject.org/gpg > /tmp/dockerkey
    sudo apt-key add /tmp/dockerkey
    sudo apt-get -y install software-properties-common
    sudo add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"
elif [[ "$UBUNTU_VERSION" =~ ^("15.04"|"15.10")$ ]]; then
    echo "==> docker is no more supported for this ($UBUNTU_VERSION) version of ubuntu" 2>&1 | tee -a $LOGFILE
else
    echo "==> docker will not be installed for this ($UBUNTU_VERSION) version of ubuntu" 2>&1 | tee -a $LOGFILE
    exit
fi

# install docker
echo "==> installing docker engine" 2>&1 | tee -a $LOGFILE
sudo apt-get update
sudo apt-get -y install docker-engine
sudo service docker start

# create docker group and add user to it
sudo groupadd docker
sudo usermod -aG docker $SSH_USERNAME

# run example docker container, making sure docker is working
docker run hello-world

# enable memory and swap accounting
sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
sudo update-grub

# requirement for autostart on ubuntu version greater than 14.10
if [[ "$UBUNTU_MAJOR_VERSION" -gt "15" ]]; then
    sudo systemctl enable docker
fi

# install docker-machine
sudo apt-get -y install wget
sudo wget -O /usr/local/bin/docker-machine https://github.com/docker/machine/releases/download/v0.9.0/docker-machine-`uname -s`-`uname -m`
sudo chmod +x /usr/local/bin/docker-machine
