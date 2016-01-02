#!/bin/bash -eux

if [[ ! "$ROS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> ros installation is disabled"
    exit
fi

# setup source-list and keys
sudo sh -c "echo 'deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main' > /etc/apt/sources.list.d/ros-latest.list"
sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-key 0xB01FA116
sudo apt-get update --fix-missing

# install ros-indigo-base
sudo apt-get -y install \
ros-$ROS_VERSION-desktop \
ros-$ROS_VERSION-perception \
ros-$ROS_VERSION-navigation \
python-catkin-tools

## setup rosdep
#sudo rosdep init
#rosdep update
