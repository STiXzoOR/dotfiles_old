#!/usr/bin/env bash

###########################
# This script updates dotfiles
# @author STiXzoOR
###########################

# include library helper for colorized echo
source ./lib_sh/echos.sh

bot "Updating submodules to latest..."
git submodule update --init --recursive --remote --merge --quiet

bot "Updating remote repo..."
git add .
git commit -m "updated submodules"
git push origin master

bot "Saving date of update..."
git config --global dotfiles.lastupdate "$(date +%Y%m%d%H%M)"

bot "Woot! All done."
