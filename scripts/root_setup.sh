#!/bin/bash

set -e

# updating and upgrading dependencies
sudo apt-get update -y -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null

# install necessary libraries for guest additions and vagrant nfs share
sudo apt-get -y -q install linux-headers-$(uname -r) build-essential dkms nfs-common

# install necessary dependencies
#sudo apt-get -y -q install curl wget git tmux firefox xvfb vim

# setup sudo to allow no-password sudo for "admin"
groupadd -r admin
usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers
