#!/bin/bash -eux

if [[ ! "$ROS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> ros installation is disabled"
    exit
fi

SSH_USER=${SSH_USERNAME:-ubuntu}

# setup source-list and keys
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-key 0xB01FA116
apt-get update --fix-missing

# install ros-indigo-base
apt-get install -y \
ros-${ROS_VERSION}-desktop-full \
ros-${ROS_VERSION}-navigation \
python-catkin-tools

# setup rosdep
rosdep init
rosdep update
