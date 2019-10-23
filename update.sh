#!/usr/bin/env bash

###########################
# This script updates dotfiles
# @author STiXzoOR
###########################

# include library helper for colorized echo
source ./lib_sh/echos.sh

bot "Updating Dotfiles to latest and greatest!\n"

running "Enter commit message"
read message
echo

running "Updating submodules"
git submodule update --init --recursive --remote --merge --quiet;ok

running "Updating remote repo"
git add -A
git commit -m "$message"
git push -u origin master --quiet;ok

running "Saving date of update"
git config --global dotfiles.lastupdate "$(date +%Y%m%d%H%M)";ok

bot "Woot! All done."
