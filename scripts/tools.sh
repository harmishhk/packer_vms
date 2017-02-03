#!/bin/bash -eux

LOGFILE=/tmp/commands.txt
touch $LOGFILE

if [[ ! "$TOOLS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    echo "==> tools installation is disabled" 2>&1 | tee -a $LOGFILE
    exit
fi

# install basic tools
echo "==> installing basic tools" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install htop tmux tree vim wget curl gdebi

# install editor/coding tools
echo "==> installing editor/coding tools" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install gdb llvm-3.6-dev clang-3.6 pylint python-autopep8

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

# install vs-code and extensions
echo "==> installing visual studio code editor and extensions" 2>&1 | tee -a $LOGFILE
wget -O /tmp/vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
sudo gdebi -n /tmp/vscode.deb
git clone https://gist.github.com/harmishhk/$CODE_EXTS_GIST_ID /tmp/vscode_exts_gist
mkdir -p /home/$SSH_USERNAME/.config/Code/User
mkdir -p /home/$SSH_USERNAME/.vscode/extensions
bash /tmp/vscode_exts_gist/vscode.sh

# install and setup zsh
echo "==> installing and setting-up z-shell" 2>&1 | tee -a $LOGFILE
sudo apt-get -y install zsh
zsh --version
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$SSH_USERNAME/.oh-my-zsh
sudo chsh $SSH_USERNAME -s $(grep /zsh$ /etc/shells | tail -1)
