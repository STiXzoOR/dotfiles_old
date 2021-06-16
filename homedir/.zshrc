# zmodload zsh/zprof # Enable for debugging
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#####################################################################################
# Enable Instant Prompt
#####################################################################################
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

#####################################################################################
# Hide Username from Prompt
#####################################################################################

export DEFAULT_USER=$(whoami)

#####################################################################################
# Source Powerlevel Settings
#####################################################################################

# [[ ! -f "${HOME}/.p10k.zsh" ]] || source "${HOME}/.p10k.zsh"
set-preset "Nord"

#####################################################################################
# Source Prezto
#####################################################################################

if [[ -s "${ZDOTDIR:-$HOME}/.dotfiles/prezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.dotfiles/prezto/init.zsh"
fi

#####################################################################################
# Source NVM
#####################################################################################

source $(brew --prefix nvm)/nvm.sh --no-use

autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use &>/dev/null
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

#####################################################################################
# Completion settings
#####################################################################################

zstyle ':completion:*' menu select

# Source fzf completion if installed
if [ "$(command -v fzf)" ]; then
  export FZF_COMPLETION_TRIGGER='**'
  source /usr/local/opt/fzf/shell/completion.zsh
fi

#####################################################################################
# Why would you type 'cd dir' if you could just type 'dir'?
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
# Recursive globbing with "**"
#####################################################################################

setopt GLOB_STAR_SHORT

# zprof # Enable for debugging
