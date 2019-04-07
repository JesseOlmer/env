#!/bin/bash

function requireroot {
	if ! [ $(id -u) = 0 ]; then
	   echo "The script needs to be run by escalating to root (sudo)." >&2
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

function installmicrok8s {
	snap install microk8s --classic
}

requireroot
installzsh
installhtop
installmicrok8s
