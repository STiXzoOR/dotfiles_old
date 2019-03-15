#!/usr/bin/env bash

###########################
# This script installs IntelliJ plugins
# @author STiXzoOR
###########################

downloads_dir=/tmp/intellij_downloads

Apps=(
	"PyCharm"
)

Plugins=(
	"8006" # Material theme UI
	"10080" # Rainbow Brackets
)

function findArchive() {
# $1: Zip
# $2: Directory
    find "$2" -name "$1"
}

function unarchive() {
# $1: Zip file
# $2: Directory
    unzip -q "$1" -d "$2"
}

function unarchiveAllInDirectory() {
# $1: Directory
    for zip in $(findArchive "*.zip" "$1"); do
        unarchive "$zip" "$1"
    done
}

function pluginDownload() {
# $1: ID
# $2: Output directory
    if [[ -d "$2" ]]; then
        local output_dir="$2"
    fi
    curl --silent --output /tmp/org.intellij.download.txt --location https://plugins.jetbrains.com/plugin/$1
    url=$(grep -o '"downloadUrl": *"[^"]*' /tmp/org.intellij.download.txt | grep -o '[^"]*$' | sed 's/^ *//g')
    fileName=$(grep -o '"name": *"[^"]*' /tmp/org.intellij.download.txt | grep -o -m 1 '[^"]*$' | sed 's/ /_/g')
    curl --silent --location http://plugins.jetbrains.com$url --output "$output_dir/$fileName.zip"
}

function installPluginsPerApp(){
# $1: App name
		output_dir=$(find ~/Library/Application\ Support -name "*$1*" -type d -maxdepth 1)
		for folder in "$(find "$downloads_dir" -type d -mindepth 1 -maxdepth 1)"
		do
			cp -R "$folder" "$output_dir"
		done
}

function installThemePerApp(){
# $1: App name
		output_dir=$(find ~/Library/Preferences -name "*$1*" -type d -maxdepth 1)
		mv "$output_dir/colors/Dracula.icls" "$output_dir/colors/Dracula_Default.icls" > /dev/null 2>&1
		ln -s ~/.dotfiles/configs/jetbrains/dracula_theme/Dracula.icls "$output_dir/colors/Dracula.icls"
}

function installSettingsPerApp(){
# $1: App name
		output_dir=$(find ~/Library/Preferences -name "*$1*" -type d -maxdepth 1)
		mv "$output_dir/options" "$output_dir/options_bak" > /dev/null 2>&1
		mkdir "$output_dir/options" > /dev/null 2>&1
		for file in ~/.dotfiles/configs/jetbrains/$1/*; do
        if [[ $? -eq 0 ]]; then
            ln -s $file "$output_dir/options/"
        fi
    done
}

case "$1" in
	--download-plugins)
		rm -Rf $downloads_dir && mkdir -p $downloads_dir

		for plugin in "${Plugins[@]}"
		do
			pluginDownload "$plugin" "$downloads_dir"
		done
	;;
	--install-plugins)
		unarchiveAllInDirectory "$downloads_dir"

		for app in "${Apps[@]}"
		do
			installPluginsPerApp "$app"
		done
	;;
	--install-theme)
		for app in "${Apps[@]}"
		do
			installThemePerApp "$app"
		done
	;;
	--install-settings)
		for app in "${Apps[@]}"
		do
			installSettingsPerApp "$app"
		done
	;;
	--cleanup)
		rm -Rf $downloads_dir
	;;
esac
