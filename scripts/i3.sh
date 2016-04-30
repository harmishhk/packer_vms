#!/bin/bash -eux

LOGFILE=$HOME/summary.txt
touch $LOGFILE

if [[ ! "$I3WM" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> i3wm installation is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

# install i3 window manager
echo "==> installing i3 window manager" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install i3
I3_LIGHTDM_CONF=/etc/lightdm/lightdm.conf.d/50-i3.conf
sudo mkdir -p $(dirname $I3_LIGHTDM_CONF)
sudo sh -c "echo '[SeatDefaults]' >> $I3_LIGHTDM_CONF"
sudo sh -c "echo 'user-session=i3' >> $I3_LIGHTDM_CONF"

# i3blocks for i3wm
echo "==> installing i3bocks for better i3 status bar" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install ruby-ronn acpi
git clone git://github.com/vivien/i3blocks /tmp/i3blocks
make -C /tmp/i3blocks clean debug
sudo make -C /tmp/i3blocks install
mkdir -p /home/$SSH_USERNAME/.config/i3blocks/scripts
cp /tmp/i3blocks/scripts/* /home/$SSH_USERNAME/.config/i3blocks/scripts

# rofi for i3wm
echo "==> installing rofi for better dmenu" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install compton wget gdebi
wget -O /tmp/rofi.deb https://launchpad.net/ubuntu/+archive/primary/+files/rofi_0.15.11-1_amd64.deb
sudo gdebi -n /tmp/rofi.deb

# other i3 related tools
echo "==> installing some i3 related tools" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install arandr lxappearance thunar
