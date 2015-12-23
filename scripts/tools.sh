#!/bin/bash

if [[ ! "$TOOLS" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
  exit
fi

SSH_USERNAME=${SSH_USERNAME:-ubuntu}

# install tools
sudo apt-get -y install vim htop tree
export EDITOR=vim

# install git
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get -y install git tig

# generate ssh keys
ssh-keygen -t rsa -b 4096 -C "$SSH_USERNAME@$HOSTNAME" -f ~/.ssh/github_rsa -N ""
ssh-keygen -t rsa -b 4096 -C "$SSH_USERNAME@$HOSTNAME" -f ~/.ssh/gitlab_rsa -N ""
ssh-keygen -t rsa -b 4096 -C "$SSH_USERNAME@$HOSTNAME" -f ~/.ssh/laas_rsa -N ""

# install window manager
sudo apt-get -y install i3

# link shared folders to user home
sudo usermod -aG vboxsf $SSH_USERNAME
ln -s /media/sf_work /home/$SSH_USERNAME/work

# install and setup zsh
sudo apt-get -y install zsh
zsh --version
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/$SSH_USERNAME/.oh-my-zsh
cp /home/$SSH_USERNAME/.oh-my-zsh/templates/zshrc.zsh-template /home/$SSH_USERNAME/.zshrc
sudo -u $SSH_USERNAME chsh -s $(grep /zsh$ /etc/shells | tail -1)
