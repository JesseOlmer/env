#!/bin/bash

function requireroot {
	if ! [ $(id -u) = 0 ]; then
	   echo "The script needs to be run by escalating to root (sudo)." >&2
	   exit 1
	fi
}

function requiresudo {
	if [ $(id -u $real_user) = 0 ]; then
		echo "The script should be run by escalating (sudo) from a non-root account." >&2
		exit 1
	fi
}

function installzsh {
	echo "Installing zsh"
	apt-get update > /dev/null
	apt-get install -y zsh powerline fonts-powerline > /dev/null
}

function installhtop {
	echo "Installing htop"
	apt-get install -y htop > /dev/null
}

function installohmyzsh {
	echo "Installing oh-my-zsh"
	if [ -d ~/.oh-my-zsh ]; then
		echo "oh-my-zsh already installed. Skipping"
		return 0
	fi
	sudo -u $real_user sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

function installzshrc {
	echo "Copying .zshrc"
	sudo -u $real_user cp .zshrc ~/
}

function installclipboardmgr {
	echo "Installing clipboard manager"
	if [ -d ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com ]; then
		echo "clipboard manager already installed. Skipping"
		return 0
	fi

	sudo -u $real_user git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
	pushd ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com
	sudo -u $real_user gnome-shell-extension-tool -e clipboard-indicator@tudmotu.com
	sudo -u $real_user glib-compile-schemas schemas
	sudo -u $real_user gsettings --schemadir schemas set org.gnome.shell.extensions.shelltile gap-between-windows 3
	popd
}

function installshelltile {
	echo "Installing shelltile"
	if [ -d ~/.local/share/gnome-shell/extensions/ShellTile@emasab.it ]; then
		echo "shelltile already installed. Skipping"
		return 0
	fi
	sudo -u $real_user git clone https://github.com/emasab/shelltile.git ~/.local/share/gnome-shell/extensions/ShellTile@emasab.it
	pushd ~/.local/share/gnome-shell/extensions/ShellTile@emasab.it
	sudo -u $real_user gnome-shell-extension-tool -e ShellTile@emasab.it
	sudo -u $real_user glib-compile-schemas schemas
	sudo -u $real_user gsettings --schemadir schemas set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Ctrl>grave']"
	sudo -u $real_user gsettings --schemadir schemas set org.gnome.shell.extensions.clipboard-indicator notify-on-copy false
	popd
}

function addzshtobashrc {
	echo "Adding zsh execution to bashrc"
	grep -Pzoq 'if \[ -t 1 ]; then\n  exec zsh\nfi' ~/.bashrc
	if [ $? -eq 0 ]; then
		echo "zsh already in bashrc. Skipping"
		return 0
	fi
	sudo -u $real_user cat <<EOT >> ~/.bashrc
if [ -t 1 ]; then
  exec zsh
fi
EOT
}

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

requireroot
requiresudo
installzsh
installhtop
installohmyzsh
installclipboardmgr
installshelltile
addzshtobashrc
