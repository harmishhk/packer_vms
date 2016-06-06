#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$ROS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> ros installation is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

echo "==> installing ros $ROS_VERSION" 2>&1 | tee -a $LOGFILE

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
sudo rosdep init
rosdep update

if [[ ! "$SPENCER" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> ros-spencer installation is disabled" 2>&1 | tee -a $LOGFILE
else
    echo "==> installing spencer related packages for ros $ROS_VERSION" 2>&1 | tee -a $LOGFILE

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
fi

if [[ ! "$GAZEBO" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> ros-gazebo installation is disabled" 2>&1 | tee -a $LOGFILE
else
    echo "==> installing gazebo and related packages for ros $ROS_VERSION" 2>&1 | tee -a $LOGFILE

    # install dependencies
    sudo apt-get -y install wget

    # setup source-list and keys
    sudo sh -c "echo 'deb http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main' > /etc/apt/sources.list.d/gazebo-stable.list"
    wget http://packages.osrfoundation.org/gazebo.key -O /tmp/gazebo.key
    sudo apt-key add /tmp/gazebo.key
    sudo apt-get update

    # install gazebo
    sudo apt-get -y install \
        ros-$ROS_VERSION-gazebo7-ros-pkgs \
        ros-$ROS_VERSION-gazebo7-ros-control

    # install pr2 simulator dependencies
    sudo apt-get -y install \
        ros-$ROS_VERSION-pr2-controller-manager \
        ros-$ROS_VERSION-pr2-msgs \
        ros-$ROS_VERSION-pr2-dashboard-aggregator \
        ros-$ROS_VERSION-pr2-controllers

    export TERM=xterm
    source /opt/ros/$ROS_VERSION/setup.bash
    git clone -b $ROS_VERSION-devel https://github.com/harmishhk/pr2_simulator.git /tmp/pr2_ws/src/pr2_simulator
    catkin config --workspace /tmp/pr2_ws -i /opt/ros/$ROS_VERSION --install
    sudo catkin build --workspace /tmp/pr2_ws
fi
