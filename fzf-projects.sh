#!/bin/bash

dir=$( dirname -- "$0"; )
configFile="$dir/.config"

editConfig() {
	read -p "Projects directory: " inputRoot 
	read -p "Editor: " inputEditor

	if [ "$inputRoot" == '' ]
	then
		inputRoot='~'
	fi

	if [ "$inputEditor" == '' ]
	then
		inputEditor="nvim"
	fi

	echo "FD_ROOT=\"$inputRoot\"" > "$configFile"
	echo "FD_CMD=($inputEditor)" >> "$configFile" 
}

if [ ! -f "$configFile" ]
then
	editConfig
fi

while getopts ":c" option; do
	case $option in
    	c) 
    		editConfig;;
	esac
done

source "$configFile"

if [ -z "$FD_ROOT" ]
then
	exit
fi

projectsPath="${FD_ROOT/#\~/$HOME}"
projects=$(find "$projectsPath" -maxdepth 5 -type d -name .git -prune -exec dirname {} \; 2>/dev/null)
selected=$(printf "$projects" | fzf --no-multi --color=16 --cycle --preview-window=border-left --preview='(cd {1} && [ -f README.* ] && cat README.* || ls -l)')

if [ ! -z "$selected" ]
then
	cd $selected
	"${FD_CMD[@]}"
fi
