#!/bin/bash -eux

if [[ ! "$DOCKER" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> docker installation is disabled"
    exit
fi

SSH_USER=${SSH_USERNAME:-ubuntu}

UBUNTU_VERSION=$(lsb_release -rs)
UBUNTU_MAJOR_VERSION=$(lsb_release -rs | cut -f1 -d .)

# install docker prerequisites
apt-get update
apt-get -y install linux-image-extra-$(uname -r)

# add docker key and repository
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
touch /etc/apt/sources.list.d/docker.list
if [[ "${UBUNTU_VERSION}" =~ "14.04" ]]; then
    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee --append /etc/apt/sources.list.d/docker.list
elif [[ "${UBUNTU_VERSION}" =~ "15.04" ]]; then
    echo "deb https://apt.dockerproject.org/repo ubuntu-vivid main" | tee --append /etc/apt/sources.list.d/docker.list
elif [[ "${UBUNTU_VERSION}" =~ "15.10" ]]; then
    echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" | tee --append /etc/apt/sources.list.d/docker.list
else
    echo "==> docker will not be installed for this (${UBUNTU_VERSION}) version of ubuntu"
    exit
fi

# install docker
apt-get update
apt-get -y install docker-engine
service docker start

# create docker group
# groupadd docker
# gpasswd -a ${USER} docker
# gpasswd -a ${SSH_USERNAME} docker
usermod -aG docker ${SSH_USER}

# run example docker container, TODO: run without sudo
docker run hello-world

# enable memory and swap accounting
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
update-grub

# requirement for autostart on ubuntu version greater than 15.04
if [[ "${UBUNTU_MAJOR_VERSION}" -gt "14" ]]; then
    systemctl enable docker
fi
