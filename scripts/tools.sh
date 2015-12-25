#!/bin/bash -eux

if [[ ! "$TOOLS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> tools installation is disabled"
    exit
fi

SSH_USERNAME=${SSH_USERNAME:-ubuntu}

UBUNTU_VERSION=$(lsb_release -rs)
UBUNTU_MAJOR_VERSION=$(lsb_release -rs | cut -f1 -d .)

# install basic tools
apt-get -y install vim htop tree

# install git
add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get -y install git tig meld

# gtk theme
if [[ "${UBUNTU_MAJOR_VERSION}" -gt "14" ]]; then
    echo "==> installing arc theme"
    wget http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_${UBUNTU_VERSION}/Release.key
    apt-key add - < Release.key
    rm Release.key
    sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_${UBUNTU_VERSION}/ /' >> /etc/apt/sources.list.d/arc-theme.list"
    apt-get update
    apt-get -y install arc-theme
else
    echo "==> installing numix theme"
    add-apt-repository -y ppa:numix/ppa
    apt-get update
    apt-get -y install numix-gtk-theme numix-icon-theme-circle
fi

# install window manager
apt-get -y install i3

# apt-get install ruby-ronn
# git clone git://github.com/vivien/i3blocks /home/${SSH_USER}/temp/i3blocks
# cd /home/${SSH_USER}/temp/i3blocks
# make clean debug
# make install
#apt-get install i3blocks

# wget -O /home/${SSH_USER}/temp https://launchpad.net/ubuntu/+archive/primary/+files/rofi_0.15.11-1_amd64.deb
# dpkg -i rofi_0.15.11-1_amd64.deb
#apt-get install rofi

apt-get -y install compton
apt-get -y install feh lxappearance

mkdir /home/${SSH_USER}/.font
wget -O /home/${SSH_USER}/.font https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf

add-apt-repository ppa:no1wantdthisname/ppa
apt-get update # && apt-get upgrade
apt-get install fontconfig-infinality
ln -s /etc/fonts/infinality/conf.d /etc/fonts/infinality/styles.conf.avail/win7

# wallpaper
apt-get install gawk
git clone https://github.com/harmishhk/bing-wallpaper /home/${SSH_USER}/software/bing-wallpaper
#cd /home/${SSH_USER}/software/bing-wallpaper&& sh setup.sh && cd

# install and setup zsh
apt-get -y install zsh
zsh --version
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/${SSH_USER}/.oh-my-zsh
#sudo -u ${SSH_USER} chsh -s $(grep /zsh$ /etc/shells | tail -1)

# link shared folders to user home
sudo usermod -aG vboxsf ${SSH_USER}
ln -s /media/sf_work /home/${SSH_USER}/work
