#/bin/bash

# zsh and fonts
apt-get update
apt-get install -y zsh powerline fonts-powerline
# oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
# copy .zshrc from repo
cp .zshrc ~/

# update bash to launch zsh
cat <<EOT >> ~/.bashrc
if [ -t 1 ]; then
  exec zsh
fi
EOT
