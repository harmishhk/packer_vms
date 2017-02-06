#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$THEME" =~ ^(true|yes|on|1|TRUE|YES|ON)$ ]]; then
    echo "==> theming is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

# font set-up
echo "==> installing and setting up fonts" 2>&1 | tee -a $LOGFILE
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
echo "gsettings set org.gnome.desktop.interface font-name 'Selawik 9'" >> /home/$SSH_USERNAME/.xprofile
echo "gsettings set org.gnome.desktop.interface monospace-font-name 'Inconsolata Medium 12'" >> /home/$SSH_USERNAME/.xprofile

# gtk theme
echo "==> installing numix theme" 2>&1 | tee -a $LOGFILE
sudo add-apt-repository -y ppa:numix/ppa
sudo apt-get update
sudo apt-get -y install gnome-settings-daemon lxappearance numix-gtk-theme numix-icon-theme-circle
echo "gsettings set org.gnome.desktop.interface gtk-theme 'Numix'" >> /home/$SSH_USERNAME/.xprofile
echo "gsettings set org.gnome.desktop.wm.preferences theme 'Numix'" >> /home/$SSH_USERNAME/.xprofile
echo "gsettings set org.gnome.desktop.interface icon-theme 'Numix-Circle'" >> /home/$SSH_USERNAME/.xprofile
echo "gconftool-2 --type=string --set /desktop/gnome/interface/gtk_theme 'Numix'" >> /home/$SSH_USERNAME/.xprofile
echo "gsettings set org.gnome.settings-daemon.plugins.cursor active false" >> /home/$SSH_USERNAME/.xprofile

# wallpaper
echo "==> setting-up bing wallpaper" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install curl feh gawk
git clone https://github.com/harmishhk/bing-wallpaper /home/$SSH_USERNAME/software/bing-wallpaper
sh /home/$SSH_USERNAME/software/bing-wallpaper/setup.sh /home/$SSH_USERNAME/software/bing-wallpaper
echo "/home/$SSH_USERNAME/software/bing-wallpaper/bing-wallpaper.sh 2>&1 > /dev/null" >> /home/$SSH_USERNAME/.xprofile

# terminal theming
echo "==> setting-up terminal theme" 2>&1 | tee -a $LOGFIL
sudo apt-get -y install git gnome-terminal wget
wget -O /home/$SSH_USERNAME/.Xresources https://raw.githubusercontent.com/chriskempson/base16-xresources/master/base16-tomorrow.dark.xresources
git clone https://github.com/chriskempson/base16-gnome-terminal.git /home/$SSH_USERNAME/.config/base16-gnome-terminal
source /home/$SSH_USERNAME/.config/base16-gnome-terminal/base16-tomorrow.dark.sh
gconftool --set --type bool /apps/gnome-terminal/profiles/base-16-tomorrow-dark/scrollback_unlimited -- true
gconftool --set --type bool /apps/gnome-terminal/profiles/base-16-tomorrow-dark/default_show_menubar -- false
gconftool --set --type bool /apps/gnome-terminal/profiles/base-16-tomorrow-dark/login_shell -- true
gconftool --set --type string /apps/gnome-terminal/profiles/base-16-tomorrow-dark/title_mode -- "ignore"
gconftool --set --type string /apps/gnome-terminal/profiles/base-16-tomorrow-dark/scrollbar_position -- "hidden"
gconftool --set --type bool /apps/gnome-terminal/profiles/base-16-tomorrow-dark/use_system_font -- false
gconftool --set --type string /apps/gnome-terminal/profiles/base-16-tomorrow-dark/font -- "Inconsolata Medium 12"
gconftool --set --type string /apps/gnome-terminal/global/default_profile -- "base-16-tomorrow-dark"
