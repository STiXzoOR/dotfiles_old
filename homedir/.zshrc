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
set_preset "Nord"

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

# source /usr/local/opt/nvm/nvm.sh --no-use

# autoload -U add-zsh-hook
# load-nvmrc() {
#   if [[ -f .nvmrc && -r .nvmrc ]]; then
#     nvm use &> /dev/null
#   fi
# }

# add-zsh-hook chpwd load-nvmrc
# load-nvmrc

#####################################################################################
# ColorLS settings
#####################################################################################

source "$(dirname $(gem which colorls))/tab_complete.sh"

alias lc="colorls -lA --sd"
alias lcg="colorls -lA --sd --gs"
alias lcr="colorls -lA --sd --report"
alias lct="colorls --tree"

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

# zprof # Enable for debugging
