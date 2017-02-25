#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$HYPERV" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]]; then
    echo "==> installation of hyperv related packagesis disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

echo "==> installing hyperv related packages" 2>&1 | tee -a $LOGFILE

sudo apt-get update
sudo apt-get -y install gdebi wget
# sudo apt-get -y install linux-headers-$(uname -r)

UBUNTU_VERSION=$(lsb_release -rs)
if [[ "$UBUNTU_VERSION" =~ "16.04" ]]; then
    sudo apt-get -y install \
        linux-virtual-lts-xenial \
        linux-tools-virtual-lts-xenial \
        linux-cloud-tools-virtual-lts-xenial
elif [[ "$UBUNTU_VERSION" =~ "14.04" ]]; then
    sudo apt-get -y install \
        linux-virtual-lts-xenial \
        hv-kvp-daemon-init \
        linux-tools-virtual-lts-xenial \
        linux-cloud-tools-virtual-lts-xenial
fi

# setup remote desktop with hyperv machine
echo "==> setting up remote desktop server" 2>&1 | tee -a $LOGFILE
if [[ "$UBUNTU_VERSION" =~ "16.04" ]]; then
    wget -O /tmp/tigervnc.deb https://dl.bintray.com/tigervnc/stable/ubuntu-16.04LTS/amd64/tigervncserver_1.7.1-1ubuntu1_amd64.deb
elif [[ "$UBUNTU_VERSION" =~ "14.04" ]]; then
    wget -O /tmp/tigervnc.deb https://dl.bintray.com/tigervnc/stable/ubuntu-14.04LTS/amd64/tigervncserver_1.7.1-3ubuntu1_amd64.deb
fi
sudo gdebi -n /tmp/tigervnc.deb
sudo apt-get install -y xrdp
echo "i3" > /home/$SSH_USERNAME/.xsession
