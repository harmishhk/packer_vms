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
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo touch /etc/apt/sources.list.d/docker.list
if [[ "$UBUNTU_VERSION" =~ "14.04" ]]; then
    echo "==> installing docker prerequisites" 2>&1 | tee -a $LOGFILE
    sudo apt-get -y install apt-transport-https ca-certificates linux-image-extra-$(uname -r) apparmor
    sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' >> /etc/apt/sources.list.d/docker.list"
elif [[ "$UBUNTU_VERSION" =~ "15.04" ]]; then
    echo "==> docker is no more supported for this ($UBUNTU_VERSION) version of ubuntu" 2>&1 | tee -a $LOGFILE
elif [[ "$UBUNTU_VERSION" =~ "15.10" ]]; then
    echo "==> installing docker prerequisites" 2>&1 | tee -a $LOGFILE
    sudo apt-get -y install apt-transport-https ca-certificates linux-image-extra-$(uname -r)
    sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-wily main' >> /etc/apt/sources.list.d/docker.list"
elif [[ "$UBUNTU_VERSION" =~ "16.04" ]]; then
    echo "==> installing docker prerequisites" 2>&1 | tee -a $LOGFILE
    sudo apt-get -y install apt-transport-https ca-certificates linux-image-extra-$(uname -r)
    sudo sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' >> /etc/apt/sources.list.d/docker.list"
else
    echo "==> docker will not be installed for this ($UBUNTU_VERSION) version of ubuntu" 2>&1 | tee -a $LOGFILE
    exit
fi

# install docker
echo "==> installing docker engine" 2>&1 | tee -a $LOGFILE
sudo apt-get update
sudo apt-get -y install docker-engine wget
sudo service docker start

# create docker group
#groupadd docker
#gpasswd -a $SSH_USERNAME docker
sudo usermod -aG docker $SSH_USERNAME

# run example docker container, making sure docker is working
docker run hello-world

# enable memory and swap accounting
sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
sudo update-grub

# requirement for autostart on ubuntu version greater than 14.10
if [[ "$UBUNTU_MAJOR_VERSION" -gt "14" ]]; then
    sudo systemctl enable docker
fi

# install docker-machine
sudo wget -O /usr/local/bin/docker-machine https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-$(uname -s)-$(uname -m)
sudo chmod +x /usr/local/bin/docker-machine
