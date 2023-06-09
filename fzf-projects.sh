#!/bin/bash

dir=$( dirname -- "$0"; )
configFile="$dir/.config"

editConfig() {
	read -p "Projects directory: " input 

	if [ "$input" != '' ]
	then
		echo $input > "$configFile"
	fi
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

configuredPath=$(cat "$configFile")

if [ -z "$configuredPath" ]
then
	exit
fi

projectsPath="${configuredPath/#\~/$HOME}"
projects=$(find "$projectsPath" -type d -maxdepth 5 -name .git -prune -exec dirname {} \;)
selected=$(printf "$projects" | fzf --no-multi --color=16 --cycle --preview-window=border-left --preview='(cd {1} && [ -f README.* ] && cat README.* || ls -l)')

if [ ! -z "$selected" ]
then
	cd $selected
	nvim
fi
