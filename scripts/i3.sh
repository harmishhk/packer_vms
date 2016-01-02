#!/bin/bash -eux

if [[ ! "$I3WM" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> i3wm installation is disabled"
    exit
fi

# install i3 window manager
echo "==> installing i3 window manager"
sudo apt-get -y install i3
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo sh -c "echo '[SeatDefaults]' >> /etc/lightdm/lightdm.conf.d/50-i3.conf"
sudo sh -c "echo 'user-session=i3' >> /etc/lightdm/lightdm.conf.d/50-i3.conf"

# i3blocks for i3wm
echo "==> installing i3bocks for better i3 status bar"
sudo apt-get -y install ruby-ronn acpi
git clone git://github.com/vivien/i3blocks /tmp/i3blocks
make -C /tmp/i3blocks clean debug
sudo make -C /tmp/i3blocks install
mkdir -p /home/$SSH_USERNAME/.config/i3blocks/scripts
cp /tmp/i3blocks/scripts/* /home/$SSH_USERNAME/.config/i3blocks/scripts

# rofi for i3wm
echo "==> installing rofi for better dmenu"
sudo apt-get -y install compton wget
wget -O /tmp/rofi.deb https://launchpad.net/ubuntu/+archive/primary/+files/rofi_0.15.11-1_amd64.deb
sudo dpkg -i /tmp/rofi.deb

# other i3 related tools
sudo apt-get -y install arandr lxappearance thunar
