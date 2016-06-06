#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$THEME" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
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
sudo apt-get -y install curl nitrogen gawk
git clone https://github.com/harmishhk/bing-wallpaper /home/$SSH_USERNAME/software/bing-wallpaper
sh /home/$SSH_USERNAME/software/bing-wallpaper/setup.sh /home/$SSH_USERNAME/software/bing-wallpaper
echo "/home/$SSH_USERNAME/software/bing-wallpaper/bing-wallpaper.sh 2>&1 > /dev/null" >> /home/$SSH_USERNAME/.xprofile

# terminal emulator
echo "==> setting-up terminal emulator theme" 2>&1 | tee -a $LOGFILE
ROXTERM_PROFILE=/home/$SSH_USERNAME/.config/roxterm.sourceforge.net/Profiles/Default
mkdir -p $(dirname $ROXTERM_PROFILE)
echo "[roxterm profile]" >> $ROXTERM_PROFILE
echo "colour_scheme=Tango" >> $ROXTERM_PROFILE
echo "font=Inconsolata Medium 12" >> $ROXTERM_PROFILE
echo "always_show_tabs=0" >> $ROXTERM_PROFILE
echo "hide_menubar=1" >> $ROXTERM_PROFILE
echo "show_resize_grip=1" >> $ROXTERM_PROFILE
echo "win_title=Terminal" >> $ROXTERM_PROFILE
echo "background_type=0" >> $ROXTERM_PROFILE
echo "saturation=1.000000" >> $ROXTERM_PROFILE
echo "login_shell=1" >> $ROXTERM_PROFILE
echo "scroll_on_keystroke=1" >> $ROXTERM_PROFILE
echo "scrollbar_pos=0" >> $ROXTERM_PROFILE
