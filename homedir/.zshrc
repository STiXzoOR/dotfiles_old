#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#####################################################################################
# POWERLEVEL9K SETTINGS
#####################################################################################

DEFAULT_FOREGROUND=blue DEFAULT_BACKGROUND=black
DEFAULT_COLOR=$DEFAULT_FOREGROUND

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1

POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=false

POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=false
POWERLEVEL9K_ALWAYS_SHOW_USER=false

POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109 %m"

POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4"
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6"
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰\uF460 "

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon root_indicator dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=( status time )

POWERLEVEL9K_VCS_CLEAN_BACKGROUND="028"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="yellow"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="magenta"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_DIR_HOME_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_DIR_HOME_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_STATUS_OK_FOREGROUND="022"
POWERLEVEL9K_STATUS_OK_BACKGROUND="$DEFAULT_FOREGROUND"

POWERLEVEL9K_STATUS_ERROR_FOREGROUND="088"
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$DEFAULT_FOREGROUND"

POWERLEVEL9K_HISTORY_FOREGROUND="$DEFAULT_FOREGROUND"

POWERLEVEL9K_TIME_FORMAT="%D{%T \uF64F}"
POWERLEVEL9K_TIME_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_TIME_BACKGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_VCS_GIT_GITHUB_ICON=""
POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=""
POWERLEVEL9K_VCS_GIT_GITLAB_ICON=""
POWERLEVEL9K_VCS_GIT_ICON=""

POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"

POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$DEFAULT_FOREGROUND"

POWERLEVEL9K_USER_ICON="\uF415"
POWERLEVEL9K_USER_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_USER_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_USER_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_USER_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="magenta"
POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_ROOT_ICON=$'\uF198'

POWERLEVEL9K_SSH_FOREGROUND="yellow"
POWERLEVEL9K_SSH_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_SSH_ICON="\uF489"

POWERLEVEL9K_HOST_LOCAL_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_HOST_LOCAL_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_HOST_REMOTE_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_HOST_REMOTE_BACKGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_HOST_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
POWERLEVEL9K_HOST_ICON_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_HOST_ICON="\uF109"

POWERLEVEL9K_OS_ICON_FOREGROUND="white"
POWERLEVEL9K_OS_ICON_BACKGROUND="$DEFAULT_BACKGROUND"

POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_LOAD_WARNING_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="red"
POWERLEVEL9K_LOAD_WARNING_FOREGROUND="yellow"
POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="028"
POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="028"

POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND_COLOR="$DEFAULT_BACKGROUND"
POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="$DEFAULT_BACKGROUND"

#####################################################################################
# Source Prezto
#####################################################################################

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#####################################################################################
# iTerm2 Shell Integration
#####################################################################################

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#####################################################################################
# Source NVM
#####################################################################################

source /usr/local/opt/nvm/nvm.sh

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

source $(dirname $(gem which colorls))/tab_complete.sh

#####################################################################################
# Add homebrew to the completion path
#####################################################################################

fpath=("/usr/local/bin/" $fpath)

#####################################################################################
# why would you type 'cd dir' if you could just type 'dir'?
#####################################################################################

setopt AUTO_CD

#####################################################################################
# Now we can pipe to multiple outputs!
#####################################################################################

setopt MULTIOS

#####################################################################################
# This makes cd=pushd
#####################################################################################

setopt AUTO_PUSHD

#####################################################################################
# This will use named dirs when possible
#####################################################################################

setopt AUTO_NAME_DIRS

#####################################################################################
# If we have a glob this will expand it
#####################################################################################

setopt GLOB_COMPLETE
setopt PUSHD_MINUS

#####################################################################################
# No more annoying pushd messages...
#####################################################################################

# setopt PUSHD_SILENT

#####################################################################################
# blank pushd goes to home
#####################################################################################

setopt PUSHD_TO_HOME

#####################################################################################
# this will ignore multiple directories for the stack.  Useful?  I dunno.
#####################################################################################

setopt PUSHD_IGNORE_DUPS

#####################################################################################
# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
#####################################################################################

setopt RM_STAR_WAIT

#####################################################################################
# use magic (this is default, but it can't hurt!)
#####################################################################################

setopt ZLE
setopt NO_HUP

#####################################################################################
# only fools wouldn't do this ;-)
#####################################################################################

export EDITOR="subl -n -w"
setopt IGNORE_EOF

#####################################################################################
# If I could disable Ctrl-s completely I would!
#####################################################################################

setopt NO_FLOW_CONTROL

#####################################################################################
# Keep echo "station" > station from clobbering station
#####################################################################################

setopt NO_CLOBBER

#####################################################################################
# Case insensitive globbing
#####################################################################################
setopt NO_CASE_GLOB

#####################################################################################
# Be Reasonable!
#####################################################################################

setopt NUMERIC_GLOB_SORT

#####################################################################################
# I don't know why I never set this before.
#####################################################################################

setopt EXTENDED_GLOB

#####################################################################################
# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
#####################################################################################

setopt RC_EXPAND_PARAM

#####################################################################################
# Who doesn't want home and end to work?
#####################################################################################

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

#####################################################################################
# Incremental search is elite!
#####################################################################################

bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward

#####################################################################################
# Search based on what you typed in already
#####################################################################################

bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward
bindkey "\eOP" run-help

#####################################################################################
# oh wow!  This is killer...  try it!
#####################################################################################

bindkey -M vicmd "q" push-line

#####################################################################################
# it's like, space AND completion.  Gnarlbot.
#####################################################################################

bindkey -M viins ' ' magic-space

#####################################################################################