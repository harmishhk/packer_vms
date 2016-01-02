#!/bin/bash -eux

if [[ ! "$TOOLS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> tools installation is disabled"
    exit
fi

# install basic tools
echo "==> installing basic tools"
sudo apt-get -y install htop roxterm tmux tree vim wget

# install git
echo "==> installing git and related tools"
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get -y install git gitk meld tig

# install atom editor
wget -O /tmp/atom.deb atom.deb https://atom.io/download/deb
sudo dpkg -i /tmp/atom.deb
apm install sync-settings
echo "\"*\":" >> /home/$SSH_USERNAME/.atom/config.cson
echo "  \"sync-settings\":" >> /home/$SSH_USERNAME/.atom/config.cson
echo "    _analyticsUserId: \"AnonymousId\"" >> /home/$SSH_USERNAME/.atom/config.cson
echo "    personalAccessToken: \""$SYNC_SETTINGS_PERSONAL__ACCESS_TOKEN"\"" >> /home/$SSH_USERNAME/.atom/config.cson
echo "    gistId: \""$SYNC_SETTINGS_GIST_ID"\"" >> /home/$SSH_USERNAME/.atom/config.cson

# install and setup zsh
echo "==> installing and setting-up z-shell"
sudo apt-get -y install zsh
zsh --version
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$SSH_USERNAME/.oh-my-zsh
sudo chsh $SSH_USERNAME -s $(grep /zsh$ /etc/shells | tail -1)
