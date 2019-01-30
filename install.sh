#!/bin/bash

function requiresudo {
	if [ $(id -u $real_user) = 0 ]; then
		echo "The script should be run by escalating (sudo) from a non-root account." >&2
		exit 1
	fi
}

function installohmyzsh {
	if [ -d ~/.oh-my-zsh ]; then
		echo "oh-my-zsh already installed. Skipping"
		return 0
	fi
	echo "Installing oh-my-zsh"
	sudo -u $real_user sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

function installzshrc {
	echo "Copying .zshrc"
	sudo -u $real_user cp .zshrc ~/
}

function installclipboardmgr {
	if [ -d ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com ]; then
		echo "clipboard manager already installed. Skipping"
		return 0
	fi
	echo "Installing clipboard manager"

	git clone https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com > /dev/null
	pushd ~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com > /dev/null
	gnome-shell-extension-tool -e clipboard-indicator@tudmotu.com
	glib-compile-schemas schemas
	gsettings --schemadir schemas set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Ctrl>grave']"
	gsettings --schemadir schemas set org.gnome.shell.extensions.clipboard-indicator notify-on-copy false
	popd > /dev/null
}

function installshelltile {
	if [ -d ~/.local/share/gnome-shell/extensions/ShellTile@emasab.it ]; then
		echo "shelltile already installed. Skipping"
		return 0
	fi
	echo "Installing shelltile"
	git clone https://github.com/emasab/shelltile.git ~/.local/share/gnome-shell/extensions/ShellTile@emasab.it > /dev/null
	pushd ~/.local/share/gnome-shell/extensions/ShellTile@emasab.it > /dev/null
	gnome-shell-extension-tool -e ShellTile@emasab.it
	glib-compile-schemas schemas
	gsettings --schemadir schemas set org.gnome.shell.extensions.shelltile gap-between-windows 3
	popd > /dev/null
}

function installremovedropdownarrows {
	if [ -d ~/.local/share/gnome-shell/extensions/remove-dropdown-arrows@mpdeimos.com ]; then
		echo "Remove Dropdown Arrows already installed. Skipping"
		return 0
	fi
	echo "Installing Remove Dropdown Arrows"
	git clone https://github.com/mpdeimos/gnome-shell-remove-dropdown-arrows.git ~/.local/share/gnome-shell/extensions/remove-dropdown-arrows@mpdeimos.com > /dev/null
	pushd ~/.local/share/gnome-shell/extensions/remove-dropdown-arrows@mpdeimos.com > /dev/null
	gnome-shell-extension-tool -e remove-dropdown-arrows@mpdeimos.com
	popd > /dev/null
}

function addzshtobashrc {
	grep -Pzoq 'if \[ -t 1 ]; then\n  exec zsh\nfi' ~/.bashrc
	if [ $? -eq 0 ]; then
		echo "zsh already in bashrc. Skipping"
		return 0
	fi
	echo "Adding zsh execution to bashrc"
	sudo -u $real_user cat <<EOT >> ~/.bashrc
if [ -t 1 ]; then
  exec zsh
fi
EOT
}

function addzshtheme {
	cp ./jesse-agnoster.zsh-theme ~/.oh-my-zsh/themes/
}

function vimrcandplugins {
	cp ./.vimrc ~/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

sudo ./elevatedsteps.sh
installohmyzsh
installclipboardmgr
installshelltile
installremovedropdownarrows
addzshtheme
addzshtobashrc
vimrcandplugins

