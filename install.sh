#/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script needs to be run by escalating to root (sudo)." >&2
   exit 1
fi

# zsh and fonts
apt-get update
apt-get install -y zsh powerline fonts-powerline
# htop
apt-get install -y htop

# The rest of the file shouldn't run escalated. sudo to the original caller account
if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

if [ $(id -u $real_user) = 0 ]; then
	echo "The script should be run by escalating (sudo) from a non-root account." >&2
	exit 1
fi

# oh-my-zsh
sudo -u $real_user sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
# copy .zshrc from repo
sudo -u $real_user cp .zshrc ~/

if [ $(grep -Pzo 'if \[ -t 1 ]; then\n  exec zsh\nfi' ~/.bashrc) ]; then
  exit 0
fi

# update bash to launch zsh
sudo -u $real_user cat <<EOT >> ~/.bashrc
if [ -t 1 ]; then
  exec zsh
fi
EOT
