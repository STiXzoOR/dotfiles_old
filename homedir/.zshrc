#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#####################################################################################
# Source Powerlevel9k Settings
#####################################################################################

source "${HOME}/.zpowerlevel9k_config"
set_preset Dracula

#####################################################################################
# Source Prezto
#####################################################################################

if [[ -s "${ZDOTDIR:-$HOME}/.dotfiles/prezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.dotfiles/prezto/init.zsh"
fi

#####################################################################################
# iTerm2 Shell Integration
#####################################################################################

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#####################################################################################
# Source NVM
#####################################################################################

source /usr/local/opt/nvm/nvm.sh

autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use &> /dev/null
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    nvm use default &> /dev/null
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

#####################################################################################
# Hide Username from Prompt
#####################################################################################

export DEFAULT_USER=`whoami`

#####################################################################################
# ColorLS settings
#####################################################################################

source "$(dirname $(gem which colorls))/tab_complete.sh"

alias lc="colorls -lA"
alias lct="colorls --tree"
alias lcr="colorls -lA --report"

#####################################################################################
# why would you type 'cd dir' if you could just type 'dir'?
#####################################################################################

setopt AUTO_CD

#####################################################################################
# This will use named dirs when possible
#####################################################################################

setopt AUTO_NAME_DIRS

#####################################################################################
# No more annoying pushd messages...
#####################################################################################

setopt PUSHD_SILENT

#####################################################################################
# Run fortune on new terminal :)
#####################################################################################

#fortune