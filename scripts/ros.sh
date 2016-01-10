#!/bin/bash -eux

if [[ ! "$ROS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> ros installation is disabled"
    exit
fi

echo "==> installing ros $ROS_VERSION"

# setup source-list and keys
sudo sh -c "echo 'deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main' > /etc/apt/sources.list.d/ros-latest.list"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
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

if [[ ! "$SPENCER" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> ros-spencer installation is disabled"
    exit
fi

echo "==> installing spencer related packages for ros $ROS_VERSION"

sudo apt-get -y install \
libmrpt-dev \
mrpt-apps \
freeglut3-dev \
libsvm-dev \
libsdl-image1.2-dev \
libpcap-dev \
libgsl0-dev \
ros-$ROS_VERSION-bfl \
ros-$ROS_VERSION-control-toolbox \
ros-$ROS_VERSION-driver-base \
ros-$ROS_VERSION-sound-play \
ros-$ROS_VERSION-joy \
ros-$ROS_VERSION-yocs-cmd-vel-mux
