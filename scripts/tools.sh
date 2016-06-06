#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$TOOLS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> tools installation is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

# install basic tools
echo "==> installing basic tools" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install htop roxterm tmux tree vim wget curl gdebi

# install git and git-lfs
echo "==> installing git and related tools" 2>&1 | tee -a $LOGFILE
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get -y install git git-svn gitk meld tig git-gui
curl -s -o /tmp/git-lfs.sh https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh
sudo bash /tmp/git-lfs.sh
sudo apt-get -y install git-lfs
git lfs install

# install atom editor
echo "==> installing and configuring atom editor" 2>&1 | tee -a $LOGFILE
wget -O /tmp/atom.deb https://atom.io/download/deb
sudo gdebi -n /tmp/atom.deb
apm install sync-settings
echo "\"*\":" >> /home/$SSH_USERNAME/.atom/config.cson
echo "  \"sync-settings\":" >> /home/$SSH_USERNAME/.atom/config.cson
echo "    _analyticsUserId: \"AnonymousId\"" >> /home/$SSH_USERNAME/.atom/config.cson
echo "    personalAccessToken: \""$ATOM_SYNC_SETTINGS_PERSONAL_ACCESS_TOKEN"\"" >> /home/$SSH_USERNAME/.atom/config.cson
echo "    gistId: \""$ATOM_SYNC_SETTINGS_GIST_ID"\"" >> /home/$SSH_USERNAME/.atom/config.cson

# install vs-code
echo "==> installing visual studio code editor" 2>&1 | tee -a $LOGFILE
wget -O /tmp/vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
sudo gdebi -n /tmp/vscode.deb

# install image tools
echo "==> installing image tools" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install gimp inkscape

# install and setup zsh
echo "==> installing and setting-up z-shell" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install zsh
zsh --version
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$SSH_USERNAME/.oh-my-zsh
sudo chsh $SSH_USERNAME -s $(grep /zsh$ /etc/shells | tail -1)
