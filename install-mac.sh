#!/bin/bash

if [ $SUDO_USER ]; then
    echo "The script should not be run in an escalated (sudo) manner." >&2
    exit 1
fi

function installohmyzsh {
	if [ -d ~/.oh-my-zsh ]; then
		echo "oh-my-zsh already installed. Skipping"
		return 0
	fi
	echo "Installing oh-my-zsh"
	$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)
}

brew cask install clipy
brew cask install iterm2
brew cask install spotify
brew install kubectx
brew install kubernetes-cli
brew install docker
brew install zsh
installohmyzsh
