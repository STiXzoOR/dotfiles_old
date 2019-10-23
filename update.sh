#!/usr/bin/env bash

###########################
# This script updates dotfiles
# @author STiXzoOR
###########################

# include library helper for colorized echo
source ./lib_sh/echos.sh

bot "Updating submodules to latest..."
git submodule update --init --recursive --remote --merge --quiet;ok

bot "Updating remote repo..."
read -p "Enter commit message: " message
git add -A
git commit -m "$message"
git push -u origin master;ok

bot "Saving date of update..."
git config --global dotfiles.lastupdate "$(date +%Y%m%d%H%M)";ok

bot "Woot! All done."
