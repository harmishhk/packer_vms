#!/bin/bash

if [[ ! "$DOCKER" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
  exit
fi

SSH_USERNAME=${SSH_USERNAME:-ubuntu}

UBUNTU_MAJOR_VERSION=$(lsb_release -rs | cut -f1 -d .)

docker_package_install() {
    # install docker
    sudo apt-get update
    sudo apt-get -y install linux-image-extra-$(uname -r)
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo touch /etc/apt/sources.list.d/docker.list
    echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' | sudo tee --append /etc/apt/sources.list.d/docker.list
    sudo apt-get update
    sudo apt-get -y install docker-engine
    sudo service docker start
    sudo docker run hello-world

    # enable memory and swap accounting
    sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
    update-grub

    # docker package does not current configure daemon to start on boot
    # for Ubuntu 15.04 and up
    if [[ "${UBUNTU_MAJOR_VERSION}" -gt "14" ]]; then
      sudo systemctl enable docker
    fi

    # reboot
    echo "rebooting the machine..."
    reboot
    sleep 60
}

give_docker_non_root_access() {
    # add the docker group if it doesn't already exist
    groupadd docker

    # add the connected "${USER}" to the docker group.
    gpasswd -a ${USER} docker
    gpasswd -a ${SSH_USERNAME} docker
}

give_docker_non_root_access
docker_package_install
