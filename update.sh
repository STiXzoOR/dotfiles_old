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
git submodule update --init --recursive --remote --merge --quiet > /dev/null 2>&1;ok

running "Updating remote repo"
git add -A > /dev/null 2>&1
git commit -m "$message" > /dev/null 2>&1
git push origin master --quiet > /dev/null 2>&1;ok

running "Saving date of update"
git config --global dotfiles.lastupdate "$(date +%Y%m%d%H%M)" > /dev/null 2>&1;ok

bot "Woot! All done."
