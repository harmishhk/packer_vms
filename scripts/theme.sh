#!/bin/bash -eux

if [[ ! "$THEME" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> theming is disabled"
    exit
fi

# font set-up
echo "==> installing and setting up fonts"
sudo add-apt-repository ppa:no1wantdthisname/ppa
sudo apt-get update # && apt-get upgrade
sudo apt-get -y install fontconfig-infinality wget
sudo ln -s /etc/fonts/infinality/conf.d /etc/fonts/infinality/styles.conf.avail/linux
mkdir /home/$SSH_USERNAME/.fonts
wget -O /home/$SSH_USERNAME/.fonts/fontawesome-webfont.ttf https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf
wget -O /home/$SSH_USERNAME/.fonts/inconsolata.zip http://www.fontsquirrel.com/fonts/download/Inconsolata
unzip -d /home/$SSH_USERNAME/.fonts /home/$SSH_USERNAME/.fonts/inconsolata.zip
wget -O /home/$SSH_USERNAME/.fonts/selawik.zip https://github.com/Microsoft/Selawik/releases/download/1.01/Selawik_Release.zip
unzip -d /home/$SSH_USERNAME/.fonts /home/$SSH_USERNAME/.fonts/selawik.zip
file /home/$SSH_USERNAME/.fonts/* | grep -vi 'ttf\|otf' | cut -d: -f1 | tr '\n' '\0' | xargs -0 rm
sudo fc-cache -f -v

# gtk theme
echo "==> installing numix theme"
sudo add-apt-repository -y ppa:numix/ppa
sudo apt-get update
sudo apt-get -y install gnome-settings-daemon lxappearance numix-gtk-theme numix-icon-theme-circle
#dbus-launch --exit-with-session gsettings set org.gnome.desktop.interface gtk-theme 'Numix'
#dbus-launch --exit-with-session gsettings set org.gnome.desktop.wm.preferences theme 'Numix'
#dbus-launch --exit-with-session gsettings set org.gnome.desktop.interface icon-theme 'Numix-Circle'
#gconftool-2 --type=string --set /desktop/gnome/interface/gtk_theme 'Numix'

# wallpaper
echo "==> setting-up bing wallpaper"
sudo apt-get -y install curl nitrogen gawk
git clone https://github.com/harmishhk/bing-wallpaper /home/$SSH_USERNAME/software/bing-wallpaper
sh /home/$SSH_USERNAME/software/bing-wallpaper/setup.sh /home/$SSH_USERNAME/software/bing-wallpaper
