#!/usr/bin/env sh
#
# Description of the script.bin/bash
# File: .functions
# Author: Marco Crisologo
# Description: This file contains custom shell functions that help to automate
# common tasks and enhance the productivity and efficiency of the user.
# Usage: source this file in the .bashrc or .zshrc file (i.e source ~/dotfiles/.functions)
#

FUNC_PATH="${HOME}/.functions"

# System Functions:

# Function to make a directory and cd into it
function mkcd() {
	mkdir -p "$1" && cd "$1"
}

# Function to extract compressed files
function extract() {
	if [ -f "$1" ]; then
		case "$1" in
			*.tar.bz2)	tar xjf "$1" ;;
			*.tar.gz)	tar xzf "$1" ;;
			*.bz2)		bunzip2 "$1" ;;
			*.rar)		unrar x "$1" ;;
			*.gz)		gunzip "$1" ;;
			*.tar)		tar xf "$1" ;;
			*.tbz2)		tar xjf "$1" ;;
			*.tgz)		tar xzf "$1" ;;
			*.zip)		unzip "$1" ;;
			*.Z)		uncompress "$1" ;;
			*.7z)		7z x "$1" ;;
			*)			echo "'$1' cannot be extracted via extract()" ;;
		esac
	else 
		echo "'$1' is not a valid file"
	fi
}

# Function to update the system
function system_update() {
	sudo apt update && sudo apt upgrade -y
}

# Function to show git status (fancy)

function dotfs() {
	export GDIR="${HOME}/.dotfiles"
	export GWORKTREE="${HOME}"
	cd "${HOME}"
	if [[ $# -gt 0 ]]; then
		git --git-dir="${GDIR}" --work-tree="${GWORKTREE}" "$@"
	else
		git-grok
	fi
}

git-grok() {
	•() { IFS=";" printf "\e[%sm" "${@:-0}"; }; [[ -t 1 ]] || •() { :; }
	
	[[ "$(pwd)" == "/" ]] && root="/" || root=""
	
	none=$(•)
	
	IFS=$'\n'; for line in $(${FUNC_PATH}/grit.rb); do
	stat=${line:0:2}
	rest=${line:3}
	case $stat in # NOTE: codes should be TWO digits so columns line up!
		"A ") tint=$(• 32) ;; # added is green
		" D") tint=$(• 31) ;; # deleted is red
		" M") tint=$(• 33) ;; # modified is yellow
		"  ") tint=$(• 37) ;; # unchanged is white
		*) tint=$(• 36)    # others are cyan
	esac
	echo "${tint}${stat}•${root}${rest}${none}"
	done | column -t -s •
}
