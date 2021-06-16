#############################################################
# Generic configuration that applies to all shells
#############################################################
export DOTFILES=$HOME/.dotfiles
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

PATH="$DOTFILES/bin:$PATH"

source ~/.shellvars
source ~/.shellfn
source ~/.shellpaths
source ~/.shellaliases
source ~/.iterm2_shell_integration.$(basename $SHELL)
