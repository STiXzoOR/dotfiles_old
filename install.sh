#!/usr/bin/env bash

#TODO: update after macOS Catalina, default mac shell: bash is changing to zsh

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# @author Adam Eivy
###########################

# include my library helpers for colorized echo and require_brew, etc
source ./lib_sh/echos.sh
source ./lib_sh/requirers.sh

bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

# Do we need to ask for sudo password or is it already passwordless?
grep -q 'NOPASSWD:     ALL' /etc/sudoers.d/$LOGNAME >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "no suder file"
  sudo -v

  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  echo "Do you want me to setup this machine to allow you to run sudo without a password?\nPlease read here to see what I am doing:\nhttp://wiki.summercode.com/sudo_without_a_password_in_mac_os_x \n"

  read -r -p "Make sudo passwordless? [y|N] " response

  if [[ $response =~ (yes|y|Y) ]]; then
    if ! grep -q "#includedir /private/etc/sudoers.d" /etc/sudoers; then
      echo '#includedir /private/etc/sudoers.d' | sudo tee -a /etc/sudoers >/dev/null
    fi
    echo -e "Defaults:$LOGNAME    !requiretty\n$LOGNAME ALL=(ALL) NOPASSWD:     ALL" | sudo tee /etc/sudoers.d/$LOGNAME
    echo "You can now run sudo commands without password!"
  fi
fi

# ###########################################################
# /etc/hosts -- spyware/ad blocking
# ###########################################################
read -r -p "Overwrite /etc/hosts with the ad-blocking hosts file from someonewhocares.org? (from ./configs/hosts file) [y|N] " response
if [[ $response =~ (yes|y|Y) ]]; then
  action "cp /etc/hosts /etc/hosts.backup"
  sudo cp /etc/hosts /etc/hosts.backup
  ok
  action "cp ./configs/system/hosts /etc/hosts"
  sudo cp ./configs/system/hosts /etc/hosts
  ok
  bot "Your /etc/hosts file has been updated. Last version is saved in /etc/hosts.backup"
else
  ok "skipped"
fi

# ###########################################################
# Git Config
# ###########################################################
GITCONFIG_INITIAL=./homedir/gitconfig_initial
GITCONFIG=./homedir/.gitconfig
response='y'
if [ -e "$GITCONFIG" ]; then
  read -r -p "Looks like you have already configured Github, would you like to configure it again? [y|N] " response
fi

if [[ $response =~ (yes|y|Y) ]]; then
  bot "OK, now I am going to update the .gitconfig for your user info:"
  rm -rf "$GITCONFIG" >/dev/null 2>&1
  cp "$GITCONFIG_INITIAL" "$GITCONFIG"

  grep 'user = GITHUBUSER' ./homedir/.gitconfig >/dev/null 2>&1
  if [[ $? = 0 ]]; then
    read -r -p "What is your git username? " githubuser

    fullname=$(osascript -e "long user name of (system info)")

    if [[ -n "$fullname" ]]; then
      lastname=$(echo $fullname | awk '{print $2}')
      firstname=$(echo $fullname | awk '{print $1}')
    fi

    if [[ -z $lastname ]]; then
      lastname=$(dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //")
    fi
    if [[ -z $firstname ]]; then
      firstname=$(dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //")
    fi
    email=$(dscl . -read /Users/$(whoami) | grep EMailAddress | sed "s/EMailAddress: //")

    if [[ ! "$firstname" ]]; then
      response='n'
    else
      echo -e "I see that your full name is $COL_YELLOW$firstname $lastname$COL_RESET"
      read -r -p "Is this correct? [Y|n] " response
    fi

    if [[ $response =~ ^(no|n|N) ]]; then
      read -r -p "What is your first name? " firstname
      read -r -p "What is your last name? " lastname
    fi
    fullname="$firstname $lastname"

    bot "Great $fullname, "

    if [[ ! $email ]]; then
      response='n'
    else
      echo -e "The best I can make out, your email address is $COL_YELLOW$email$COL_RESET"
      read -r -p "Is this correct? [Y|n] " response
    fi

    if [[ $response =~ ^(no|n|N) ]]; then
      read -r -p "What is your email? " email
      if [[ ! $email ]]; then
        error "you must provide an email to configure .gitconfig"
        exit 1
      fi
    fi

    running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)"

    # test if gnu-sed or MacOS sed

    sed -i "s/GITHUBFULLNAME/$firstname $lastname/" ./homedir/.gitconfig >/dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
      echo
      running "looks like you are using MacOS sed rather than gnu-sed, accommodating"
      sed -i '' "s/GITHUBFULLNAME/$firstname $lastname/" ./homedir/.gitconfig
      sed -i '' 's/GITHUBEMAIL/'$email'/' ./homedir/.gitconfig
      sed -i '' 's/GITHUBUSER/'$githubuser'/' ./homedir/.gitconfig
      ok
    else
      echo
      bot "looks like you are already using gnu-sed. woot!"
      sed -i 's/GITHUBEMAIL/'$email'/' ./homedir/.gitconfig
      sed -i 's/GITHUBUSER/'$githubuser'/' ./homedir/.gitconfig
    fi
  fi
fi

# ###########################################################
# Install non-brew various tools (PRE-BREW Installs)
# ###########################################################
bot "ensuring build/install tools are available"
if !xcode-select --print-path &>/dev/null; then
  # prompt user to install the XCode Command Line Tools
  xcode-select --install &>/dev/null

  # wait until the XCode Command Line Tools are installed
  until xcode-select --print-path &>/dev/null; do
    sleep 5
  done

  ok 'XCode Command Line Tools Installed'

  # prompt user to agree to the terms of the Xcode license
  # https://github.com/alrra/dotfiles/issues/10
  sudo xcodebuild -license
  ok 'Agree with the XCode Command Line Tools licence'
fi

# ###########################################################
# install homebrew (CLI Packages)
# ###########################################################
running "checking homebrew..."
brew_bin=$(which brew) 2>&1 >/dev/null
if [[ $? != 0 ]]; then
  action "installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
else
  ok
  bot "Homebrew"
  read -r -p "run brew update && upgrade? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    action "updating homebrew..."
    brew update
    ok "homebrew updated"
    action "upgrading brew packages..."
    brew upgrade
    ok "brews upgraded"
  else
    ok "skipped brew package upgrades."
  fi
fi

# ###########################################################
# install brew cask (UI Packages)
# ###########################################################
# running "checking brew-cask install"
# output=$(brew tap | grep cask)
# if [[ $? != 0 ]]; then
#   action "installing brew-cask"
#   require_brew homebrew/cask-cask
# fi
# brew tap caskroom/versions > /dev/null 2>&1
# ok

# just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

# skip those GUI clients, git command-line all the way
require_brew git
# update zsh to latest
require_brew zsh
# update ruby to latest
# use versions of packages installed with homebrew
RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl) --with-readline-dir=$(brew --prefix readline) --with-libyaml-dir=$(brew --prefix libyaml)"
require_brew ruby
# set zsh as the user login shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
  bot "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
  # sudo bash -c 'echo "/usr/local/bin/zsh" >> /etc/shells'
  # chsh -s /usr/local/bin/zsh
  sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh >/dev/null 2>&1
  ok
fi

# install pretzo-zsh
read -r -p "Install prezto zsh? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  running "installing pretzo-zsh"
  zsh ./lib_sh/install_prezto.zsh
  ok
fi

# access airport binary systemwide for easy configuration
if [[ ! -e /usr/sbin/airport ]]; then
  running "linking airport binary"
  sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/sbin/airport >/dev/null 2>&1
  ok
fi

bot "Dotfiles Setup"
read -r -p "symlink ./homedir/* files in ~/ (these are the dotfiles)? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  bot "creating symlinks for project dotfiles..."
  pushd homedir >/dev/null 2>&1
  now=$(date +"%Y.%m.%d.%H.%M.%S")

  for file in .*; do
    if [[ $file == "." || $file == ".." ]]; then
      continue
    fi
    running "~/$file"
    # if the file exists:
    if [[ -e ~/$file ]]; then
      mkdir -p ~/.dotfiles_backup/$now
      mv ~/$file ~/.dotfiles_backup/$now/$file
      echo "backup saved as ~/.dotfiles_backup/$now/$file"
    fi
    # symlink might still exist
    unlink ~/$file >/dev/null 2>&1
    # create the link
    ln -s ~/.dotfiles/homedir/$file ~/$file
    echo -en '\tlinked'
    ok
  done

  popd >/dev/null 2>&1
fi

bot "VIM Setup"
read -r -p "Do you want to install vim plugins now? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  bot "Installing vim plugins"
  # cmake is required to compile vim bundle YouCompleteMe
  # require_brew cmake
  vim +PluginInstall +qall >/dev/null 2>&1
  ok
else
  ok "skipped. Install by running :PluginInstall within vim"
fi

read -r -p "Install fonts? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  bot "installing fonts"
  # need fontconfig to install/build fonts
  require_brew fontconfig
  ./fonts/install.sh
  brew tap homebrew/cask-fonts
  require_cask font-fontawesome
  require_cask font-awesome-terminal-fonts
  require_cask font-hack
  require_cask font-hack-nerd-font
  require_cask font-fira-code
  require_cask font-fira-mono
  require_cask font-fira-code-nerd-font
  require_cask font-fira-mono-nerd-font
  require_cask font-fira-mono-for-powerline
  require_cask font-hasklig
  require_cask font-menlo-for-powerline
  require_cask font-meslo-lg
  require_cask font-meslo-lg-nerd-font
  require_cask font-meslo-for-powerline
  require_cask font-roboto
  require_cask font-roboto-mono
  require_cask font-roboto-mono-nerd-font
  require_cask font-roboto-mono-for-powerline
  require_cask font-source-code-pro
  require_cask font-source-code-pro-for-powerline
  ok
fi

# gem_ver=$(ls /Library/Ruby/Gems | cut -f1 -d '/')
# if [[ -n "$gem_ver" ]]; then
#   running "Fixing Ruby Gems Directory Permissions"
#   sudo chown -R $(whoami) /Library/Ruby/Gems/$gem_ver
#   ok
# fi

# node version manager
require_brew nvm

# nvm
require_nvm stable

# always pin versions (no surprises, consistent dev/build machines)
npm config set save-exact true

#####################################
# Now we can switch to node.js mode
# for better maintainability and
# easier configuration via
# JSON files and inquirer prompts
#####################################

bot "installing npm tools needed to run this project..."
npm install
ok

read -r -p "Install packages/tools/apps? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  bot "installing packages from config.js..."
  node index.js
  ok

  running "cleanup homebrew"
  brew cleanup --force >/dev/null 2>&1
  rm -f -r /Library/Caches/Homebrew/* >/dev/null 2>&1
  ok
fi

bot "OS Configuration"
read -r -p "Do you want to update the system configurations? [y|N] " response
if [[ -z $response || $response =~ ^(n|N) ]]; then
  open /Applications/iTerm.app
  bot "All done"
  exit
fi

###############################################################################
bot "Configuring System"
###############################################################################
# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
running "closing any system preferences to prevent issues with automated changes"
osascript -e 'tell application "System Preferences" to quit'
ok

###############################################################################
bot "Security"
###############################################################################
running "Enable install from Anywhere"
sudo spctl --master-disable
ok

running "Disable remote apple events"
sudo systemsetup -setremoteappleevents off
ok

running "Disable remote login"
sudo systemsetup -setremotelogin off
ok

running "Disable wake-on modem"
sudo systemsetup -setwakeonmodem off
ok

running "Disable wake-on LAN"
sudo systemsetup -setwakeonnetworkaccess off
ok

running "Disable guest account login"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
ok

################################################
bot "General UI/UX"
################################################
running "Set computer name (as done via System Preferences → Sharing)"
sudo scutil --set ComputerName "STiX's MacBook Pro"
sudo scutil --set HostName "stix-macbook-pro"
sudo scutil --set LocalHostName "stix-macbook-pro"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "stix-macbook-pro"
ok

running "Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "
ok

# running "Disable transparency in the menu bar and elsewhere on Yosemite"
# defaults write com.apple.universalaccess reduceTransparency -bool true;ok

running "Set highlight color to steel blue"
defaults write NSGlobalDomain AppleHighlightColor -string "0.172549019607843 0.349019607843137 0,501960784313725"
ok

running "Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
ok

running "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
ok
# Possible values: `WhenScrolling`, `Automatic` and `Always`

running "Disable the over-the-top focus ring animation"
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false
ok

running "Adjust toolbar title rollover delay"
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0
ok

# running "Disable smooth scrolling"
# (Uncomment if you’re on an older Mac that messes up the animation)
# defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false;ok

running "Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
ok

running "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
ok

running "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
ok

running "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
ok

running "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
ok

running "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false
ok

running "Remove duplicates in the “Open With” menu (also see 'lscleanup' alias)"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
ok

running "Display ASCII control characters using caret notation in standard text views"
Try e.g. $(
  cd /tmp
  unidecode "\x{0000}" >cc.txt
  open -e cc.txt
)
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
ok

running "Disable Resume system-wide"
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
ok

running "Disable automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
ok

# running "Disable the crash reporter"
# defaults write com.apple.CrashReporter DialogType -string "none";ok

running "Set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true
ok

# running "Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)"
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding;ok

running "Reveal IP, hostname, OS, etc. when clicking clock in login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
ok

# running "Disable Notification Center and remove the menu bar icon"
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist > /dev/null 2>&1;ok

running "Disable automatic capitalization as it’s annoying when typing code"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
ok

running "Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
ok

running "Disable automatic period substitution as it’s annoying when typing code"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
ok

running "Disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
ok

running "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
ok

###############################################################################
bot "Trackpad, mouse, keyboard, Bluetooth accessories, and input"
###############################################################################

# running "Trackpad: enable tap to click for this user and for the login screen"
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1;ok

# running "Trackpad: map bottom right corner to right-click"
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true;ok

# running "Disable 'natural' (Lion-style) scrolling"
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false;ok

running "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
ok

running "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
ok

# running "Use scroll gesture with the Ctrl (^) modifier key to zoom"
# defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
# defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144;ok
# running "Follow the keyboard focus while zoomed in"
# defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true;ok

running "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
ok

running "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
ok

running "Set language and text formats (english/GR)"
defaults write NSGlobalDomain AppleLanguages -array "en" "el"
defaults write NSGlobalDomain AppleLocale -string "en_GR@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
ok

running "Show language menu in the top right corner of the boot screen"
defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true
ok

running "Set timezone to Europe/Athens;" #see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Athens" >/dev/null
ok

# running "Stop iTunes from responding to the keyboard media keys"
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null;ok

###############################################################################
bot "Energy saving" #
###############################################################################

running "Disable lid wakeup"
sudo pmset -a lidwake 0
ok

running "Disable auto power off"
sudo pmset -a autopoweroff 0
ok

running "Disable auto restart on power loss"
sudo pmset -a autorestart 0
ok

running "Disable machine sleep"
sudo pmset -a sleep 0
ok

running "Sleep the display after 60 minutes"
sudo pmset -a displaysleep 60
ok

running "Disable standby mode"
sudo pmset -a standby 0
ok

running "Set standby delay to 24 hours (default is 1 hour)"
sudo pmset -a standbydelay 86400
ok

running "Disable wake from iPhone/Watch (eg. When iPhone or Apple Watch come near)"
sudo pmset -a proximitywake 0
ok

running "Disable periodically wake of machine for network and updates"
sudo pmset -a powernap 0
ok

running "Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on
ok

# running "Never go into computer sleep mode"
# sudo systemsetup -setcomputersleep Off > /dev/null;ok

# Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
running "Disable hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0
ok

running "Remove the sleep image file to save disk space"
sudo rm /private/var/vm/sleepimage
ok

running "Create a zero-byte file instead…"
sudo touch /private/var/vm/sleepimage
ok

running "…and make sure it can’t be rewritten"
sudo chflags uchg /private/var/vm/sleepimage
ok

###############################################################################
bot "Screen"
###############################################################################

running "Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
ok

running "Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
ok

running "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"
ok

running "Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true
ok

running "Enable subpixel font rendering on non-Apple LCDs"
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1
ok

running "Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
ok

###############################################################################
bot "Finder"
###############################################################################

running "Allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true
ok

running "Disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true
ok

running "Set Desktop as the default location for new Finder windows"
# For other paths, use 'PfLo' and 'file:///full/path/here/'
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"
ok

running "Show icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
ok

running "Show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true
ok

running "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
ok

running "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true
ok

running "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true
ok

# running "Display full POSIX path as Finder window title"
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true;ok

running "Keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

running "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
ok

running "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
ok

running "Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
ok

running "Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0
ok

running "Avoid creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
ok

running "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
ok

running "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
ok

running "Show item info near icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
ok

running "Show item info to the right of the icons on the desktop"
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
ok

running "Enable snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
ok

running "Increase grid spacing for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
ok

running "Increase the size of icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
ok

running "Use column list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
ok

running "Use sort by Application in all Finder windows by default"
defaults write com.apple.finder FXPreferredGroupBy -string "Application"
ok

running "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false
ok

running "Empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true
ok

# running "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true;ok

running "Show the ~/Library folder"
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library
ok

running "Show the /Volumes folder"
sudo chflags nohidden /Volumes
ok

running "Expand the following File Info panes: “General”, “Open with”, and “Sharing & Permissions”"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true
ok

###############################################################################
bot "Dock & Dashboard"
###############################################################################

# running "Enable highlight hover effect for the grid view of a stack (Dock)"
# defaults write com.apple.dock mouse-over-hilite-stack -bool true;ok

running "Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36
ok

running "Change minimize/maximize window effect to scale"
defaults write com.apple.dock mineffect -string "scale"
ok

running "Enable magnification"
defaults write com.apple.dock magnification -bool true
ok

running "Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true
ok

running "Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
ok

running "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true
ok

# running "Wipe all (default) app icons from the Dock"
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array;ok

# running "Show only open applications in the Dock"
#defaults write com.apple.dock static-only -bool true;ok

# running "Don’t animate opening applications from the Dock"
# defaults write com.apple.dock launchanim -bool false;ok

running "Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1
ok

# running "Don’t group windows by application in Mission Control"
# (i.e. use the old Exposé behavior instead)
# defaults write com.apple.dock expose-group-by-app -bool false;ok

# running "Don’t automatically rearrange Spaces based on most recent use"
# defaults write com.apple.dock mru-spaces -bool false;ok

running "Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0
ok

# running "Remove the animation when hiding/showing the Dock"
# defaults write com.apple.dock autohide-time-modifier -float 0;ok

# running "Automatically hide and show the Dock"
# defaults write com.apple.dock autohide -bool true;ok

running "Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true
ok

# running "Don’t show recent applications in Dock"
# defaults write com.apple.dock show-recents -bool false;ok

# running "Disable the Launchpad gesture (pinch with thumb and three fingers)"
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0;ok

running "Reset Launchpad, but keep the desktop wallpaper intact"
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete
ok

running "Add iOS & Watch Simulator to Launchpad"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"
ok

bot "Hot corners"
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
running "Top left screen corner → Mission Control"
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
running "Top right screen corner → Desktop"
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
running "Bottom left screen corner → Start screen saver"
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
bot "Safari & WebKit"
###############################################################################

running "Don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
ok

running "Press Tab to highlight each item on a web page"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
ok

running "Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
ok

running "Set Safari’s home page to ‘about:blank’ for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"
ok

running "Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
ok

# For Mojave and up enable the keyboard shortcut but it requires to disable system integrity
# For High Sierra and below enable the default one
running "Allow hitting the Backspace key to go to the previous page in history"
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true;ok
defaults write com.apple.Safari NSUserKeyEquivalents -dict-add Back "\U232b"

running "Hide Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false
ok

running "Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false
ok

running "Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
ok

running "Enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
ok

running "Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
ok

running "Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"
ok

running "Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
ok

running "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
ok

running "Enable continuous spellchecking"
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
ok

running "Disable auto-correct"
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
ok

running "Disable AutoFill"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
ok

running "Warn about fraudulent websites"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
ok

running "Disable plug-ins"
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false
ok

running "Disable Java"
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false
ok

running "Block pop-up windows"
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
ok

# runngin "Disable auto-playing video"
# defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
# defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
# defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false;ok

running "Enable Do Not Track"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
ok

running "Update extensions automatically"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
ok

###############################################################################
bot "Mail"
###############################################################################

running "Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true
ok

running "Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
ok

running "Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"
ok

running "Display emails in threaded mode, sorted by date (oldest at the top)"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"
ok

running "Disable inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true
ok

running "Disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"
ok

###############################################################################
bot "Spotlight"
###############################################################################

# running "Hide Spotlight tray-icon (and subsequent helper)"
# sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search;ok

# Issue on macOS Mojave:
# Rich Trouton covers the move of /Volumes to no longer being world writable as of Sierra (10.12)
# https://derflounder.wordpress.com/2016/09/21/macos-sierras-volumes-folder-is-no-longer-world-writable
# running "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed"
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
# sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes";ok
running "Change indexing order and disable some file types from being indexed"
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}' \
  '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
  '{"enabled" = 0;"name" = "MENU_OTHER";}' \
  '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
  '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
  '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
ok

running "Load new settings before rebuilding the index"
killall mds >/dev/null 2>&1
ok

running "Make sure indexing is enabled for the main volume"
sudo mdutil -i on / >/dev/null
ok

running "Rebuild the index from scratch"
sudo mdutil -E / >/dev/null
ok

###############################################################################
bot "Time Machine"
###############################################################################

running "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
ok

running "Disable local Time Machine backups"
hash tmutil &>/dev/null && sudo tmutil disablelocal
ok

###############################################################################
bot "Activity Monitor"
###############################################################################

running "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
ok

running "Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5
ok

# Show processes in Activity Monitor
# 100: All Processes
# 101: All Processes, Hierarchally
# 102: My Processes
# 103: System Processes
# 104: Other User Processes
# 105: Active Processes
# 106: Inactive Processes
# 106: Inactive Processes
# 107: Windowed Processes
running "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 100
ok

running "Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
ok

running "Set columns for each tab"
defaults write com.apple.ActivityMonitor "UserColumnsPerTab v5.0" -dict \
  '0' '( Command, CPUUsage, CPUTime, Threads, PID, UID, Ports )' \
  '1' '( Command, ResidentSize, Threads, Ports, PID, UID,  )' \
  '2' '( Command, PowerScore, 12HRPower, AppSleep, UID, powerAssertion )' \
  '3' '( Command, bytesWritten, bytesRead, Architecture, PID, UID, CPUUsage )' \
  '4' '( Command, txBytes, rxBytes, PID, UID, txPackets, rxPackets, CPUUsage )'
ok

running "Sort columns in each tab"
defaults write com.apple.ActivityMonitor UserColumnSortPerTab -dict \
  '0' '{ direction = 0; sort = CPUUsage; }' \
  '1' '{ direction = 0; sort = ResidentSize; }' \
  '2' '{ direction = 0; sort = 12HRPower; }' \
  '3' '{ direction = 0; sort = bytesWritten; }' \
  '4' '{ direction = 0; sort = txBytes; }'
ok

running "Update refresh frequency (in seconds)"
# 1: Very often (1 sec)
# 2: Often (2 sec)
# 5: Normally (5 sec)
defaults write com.apple.ActivityMonitor UpdatePeriod -int 2
ok

running "Show Data in the Disk graph (instead of IO)"
defaults write com.apple.ActivityMonitor DiskGraphType -int 1
ok

running "Show Data in the Network graph (instead of packets)"
defaults write com.apple.ActivityMonitor NetworkGraphType -int 1
ok

running "Change Dock Icon"
# 0: Application Icon
# 2: Network Usage
# 3: Disk Activity
# 5: CPU Usage
# 6: CPU History
defaults write com.apple.ActivityMonitor IconType -int 3
ok

###############################################################################
bot "Address Book, Dashboard, iCal, TextEdit, and Disk Utility"
###############################################################################

running "Enable the debug menu in Address Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true
ok

running "Enable Dashboard dev mode (allows keeping widgets on the desktop)"
defaults write com.apple.dashboard devmode -bool true
ok

running "Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0
ok

running "Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
ok

running "Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true
ok

running "Auto-play videos when opened with QuickTime Player"
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true
ok

###############################################################################
bot "Mac App Store"
###############################################################################

running "Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true
ok

running "Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true
ok

running "Enable the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
ok

running "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
ok

running "Automatically download apps purchased on other Macs"
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
ok

running "Turn on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true
ok

###############################################################################
bot "Photos" #
###############################################################################

running "Prevent Photos from opening automatically when devices are plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
ok

###############################################################################
bot "Messages"
###############################################################################

running "Disable automatic emoji substitution (i.e. use plain text smileys)"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
ok

running "Disable smart quotes as it’s annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
ok

running "Disable continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false
ok

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

running "Disable the all too sensitive backswipe on trackpads"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
ok

running "Disable the all too sensitive backswipe on Magic Mouse"
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false
ok

running "Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true
ok

running "Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true
ok

###############################################################################
bot "Transmission"
###############################################################################

running "Use ~/Documents/Torrents to store incomplete downloads"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"
ok

running "Use ~/Downloads to store completed downloads"
defaults write org.m0k.transmission DownloadLocationConstant -bool true
ok

running "Don’t prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false
ok

running "Don’t prompt for confirmation before removing non-downloading active transfers"
defaults write org.m0k.transmission CheckRemoveDownloading -bool true
ok

running "Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
ok

running "Enabling queue"
defaults write org.m0k.transmission Queue -bool true
ok

running "Setting queue maximum downloads"
defaults write org.m0k.transmission QueueDownloadNumber -integer 1
ok

running "Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false
ok

running "Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false
ok

running "Setting IP block list"
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
ok

running "Randomize port on launch"
defaults write org.m0k.transmission RandomPort -bool true
ok

###############################################################################
bot "Xcode"
###############################################################################

running "Create xcode custom theme folder"
CUSTOM_THEME_DIR=~/Library/Developer/Xcode/UserData/FontAndColorThemes
mkdir -p $CUSTOM_THEME_DIR/
ok

running "Install dracula theme"
ln -s ~/.dotfiles/configs/xcode/dracula_theme/Dracula.xccolortheme $CUSTOM_THEME_DIR/Dracula.xccolortheme
ok

running "Install nord theme"
ln -s ~/.dotfiles/configs/xcode/nord_theme/src/Nord.xccolortheme $CUSTOM_THEME_DIR/Nord.xccolortheme
ok

running "Change theme to nord"
defaults write com.apple.dt.Xcode XCFontAndColorCurrentTheme -string Nord.xccolortheme
ok

running "Trim trailing whitespace"
defaults write com.apple.dt.Xcode DVTTextEditorTrimTrailingWhitespace -bool true
ok

running "Trim whitespace only lines"
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true
ok

# running "Show invisible characters"
# defaults write com.apple.dt.Xcode DVTTextShowInvisibleCharacters -bool true;ok

running "Show line numbers"
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true
ok

running "Reduce the number of compile tasks and stop indexing"
defaults write com.apple.dt.XCode IDEIndexDisable 1
ok

# running "Enable internal debug menu"
# defaults write com.apple.dt.Xcode ShowDVTDebugMenu -bool true;ok

running "Show all devices and their information you have plugged in before"
defaults read com.apple.dt.XCode DVTSavediPhoneDevices
ok

running "Show ruler at 80 chars"
defaults write com.apple.dt.Xcode DVTTextShowPageGuide -bool true
defaults write com.apple.dt.Xcode DVTTextPageGuideLocation -int 80
ok

running "Map ⌃⌘L to show last change for the current line"
defaults write com.apple.dt.Xcode NSUserKeyEquivalents -dict-add "Show Last Change For Line" "@^l"
ok

running "Show build time"
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES
ok

running "Improve performance"
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks 5
ok

running "Improve performance by leveraging multi-core CPU"
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks $(sysctl -n hw.ncpu)
ok

running "Delete these settings"
defaults delete com.apple.dt.XCode IDEIndexDisable
ok

###############################################################################
bot "Twitter" #
###############################################################################

running "Disable smart quotes as it’s annoying for code tweets"
defaults write com.twitter.twitter-mac AutomaticQuoteSubstitutionEnabled -bool false
ok

running "Show the app window when clicking the menu bar icon"
defaults write com.twitter.twitter-mac MenuItemBehavior -int 1
ok

running "Enable the hidden ‘Develop’ menu"
defaults write com.twitter.twitter-mac ShowDevelopMenu -bool true
ok

running "Open links in the background"
defaults write com.twitter.twitter-mac openLinksInBackground -bool true
ok

running "Allow closing the ‘new tweet’ window by pressing $(Esc)"
defaults write com.twitter.twitter-mac ESCClosesComposeWindow -bool true
ok

running "Show full names rather than Twitter handles"
defaults write com.twitter.twitter-mac ShowFullNames -bool true
ok

running "Hide the app in the background if it’s not the front-most window"
defaults write com.twitter.twitter-mac HideInBackground -bool true
ok

###############################################################################
bot "Tweetbot" #
###############################################################################

running "Bypass the annoyingly slow t.co URL shortener"
defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true
ok

###############################################################################
bot "VLC"
###############################################################################

running "Install settings"
if [ ! -d ~/Library/Preferences/org.videolan.vlc ]; then
  mkdir -p ~/Library/Preferences/org.videolan.vlc
fi

cp -f ./configs/vlc/vlcrc ~/Library/Preferences/org.videolan.vlc/ 2>/dev/null
cp -f ./configs/vlc/org.videolan.vlc.plist ~/Library/Preferences/org.videolan.vlc.plist 2>/dev/null
ok

###############################################################################
bot "Spotify"
###############################################################################

SPOTIFY_TUI_CONFIG_INITIAL=./configs/spotify/spotify-tui/client.yml
SPOTIFY_TUI_CONFIG=~/.config/spotify-tui/client.yml
response='y'
if [ -e "$SPOTIFY_TUI_CONFIG" ]; then
  read -r -p "Looks like you have already configured spotify-tui authentication, would you like to configure it again? [y|N] " response
fi

if [[ $response =~ (yes|y|Y) ]]; then
  running "Configure spotify-tui authentication"

  if [ ! -d ~/.config/spotify-tui ]; then
    mkdir -p ~/.config/spotify-tui
  else
    rm -rf "$SPOTIFY_TUI_CONFIG" >/dev/null 2>&1
    cp "$SPOTIFY_TUI_CONFIG_INITIAL" "$SPOTIFY_TUI_CONFIG"
  fi

  grep 'client_id: CLIENT_ID' "$SPOTIFY_TUI_CONFIG" >/dev/null 2>&1
  if [[ $? = 0 ]]; then
    read -r -p "Please enter your client id: " tuiclientid
    read -r -p "Please enter your client secret: " tuiclientsecret

    action "replacing items in client.yml with your info"

    sed -i "s/CLIENT_ID/$tuiclientid/" "$SPOTIFY_TUI_CONFIG" >/dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
      echo
      running "looks like you are using MacOS sed rather than gnu-sed, accommodating"
      sed -i '' "s/CLIENT_ID/$tuiclientid/" "$SPOTIFY_TUI_CONFIG"
      sed -i '' "s/CLIENT_SECRET/$tuiclientsecret/" "$SPOTIFY_TUI_CONFIG"
      ok
    else
      echo
      bot "looks like you are already using gnu-sed. woot!"
      sed -i "s/CLIENT_SECRET/$tuiclientsecret/" "$SPOTIFY_TUI_CONFIG"
      ok
    fi
  fi
fi

response='y'
security find-generic-password -s spotifyd >/dev/null 2>&1
if [[ $? = 0 ]]; then
  read -r -p "Looks like you have already configured spotifyd authentication, would you like to configure it again? [y|N] " response
fi

if [[ $response =~ (yes|y|Y) ]]; then
  running "Configure spotifyd authentication"

  read -r -p "Please enter your spotify id: " spotifyid
  read -r -p "Please enter your spotify password: " spotifypassword

  action "adding login credentials to keychain access"

  security add-generic-password -U -s spotifyd -D rust-keyring -a $spotifyid -w $spotifypassword
  ok
fi

running "Install spotifyd settings"
if [ ! -d ~/.config/spotifyd ]; then
  mkdir -p ~/.config/spotifyd
fi

ln -sf ~/.dotfiles/configs/spotify/spotifyd/spotifyd.conf ~/.config/spotifyd/spotifyd.conf 2>/dev/null
ok

running "Install spicetify settings"
if [ ! -d ~/spicetify_data ]; then
  mkdir -p ~/spicetify_data
fi

ln -sf ~/.dotfiles/configs/spotify/spicetify/config.ini ~/spicetify_data/config.ini 2>/dev/null
ok

running "Install spicetify themes"
ln -sf ~/.dotfiles/configs/spotify/spicetify/themes ~/spicetify_data/Themes 2>/dev/null
ok

running "Change theme to nord"
spicetify config current_theme Nord 2>/dev/null
ok
spicetify backup apply 2>/dev/null
ok

###############################################################################
bot "Karabiner Elements"
###############################################################################

running "Install settings"
if [ ! -d ~/.config/karabiner ]; then
  mkdir -p ~/.config/karabiner
fi

ln -sf ~/.dotfiles/configs/karabiner/karabiner.json ~/.config/karabiner/karabiner.json 2>/dev/null
ok

###############################################################################
bot "Visual Studio Code"
###############################################################################

running "Install extensions"
while read -r module; do
  code --install-extension "$module" || true
done <"~/.dotfiles/configs/vscode/extensions.txt"
ok

running "Install settings"
if [ ! -d ~/Library/Application\ Support/Code/User ]; then
  mkdir -p ~/Library/Application\ Support/Code/User
fi

ln -sf ~/.dotfiles/configs/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json 2>/dev/null
ok

###############################################################################
bot "Arduino IDE"
###############################################################################

running "Change theme to dracula"
mv /Applications/Arduino.app/Contents/Java/lib/theme /Applications/Arduino.app/Contents/Java/lib/theme_backup
ln -sf ~/.dotfiles/configs/arduino/dracula_theme/theme /Applications/Arduino.app/Contents/Java/lib/theme 2>/dev/null
ok

###############################################################################
bot "ColorLS"
###############################################################################

running "Install dracula colors"
if [ ! -d ~/.config/colorls ]; then
  mkdir -p ~/.config/colorls
fi

ln -sf ~/.dotfiles/configs/colorls/dark_colors.yaml ~/.config/colorls/dark_colors.yaml 2>/dev/null
ok

###############################################################################
bot "Terminal & iTerm2"
###############################################################################

running "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4
ok

running "Install dracula theme in Terminal.app"
open "./configs/terminal/dracula_theme/Dracula.terminal"
sleep 1 # Wait a bit to make sure the theme is loaded
ok

running "Install nord theme in Terminal.app"
open "./configs/terminal/nord_theme/src/xml/Nord.terminal"
sleep 1 # Wait a bit to make sure the theme is loaded
ok

running "Use nord theme by default in Terminal.app"
TERM_PROFILE='Nord'
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')"
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
  defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}"
  defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}"
fi
ok

running "Enable “focus follows mouse” for Terminal.app and all X11 apps"
# i.e. hover over a window and start `typing in it without clicking first
defaults write com.apple.terminal FocusFollowsMouse -bool true
ok

running "Tell iTerm2 to use the custom preferences in the directory"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
ok
running "Specify the preferences directory"
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${HOME}/.dotfiles/configs/iterm2"
ok

running "Install dracula theme for iTerm (opening file)"
open "./configs/iterm2/dracula_theme/Dracula.itermcolors"
sleep 1 # Wait a bit to make sure the theme is loaded
ok

running "Install nord theme for iTerm (opening file)"
open "./configs/iterm2/nord_theme/src/xml/Nord.itermcolors"
sleep 1 # Wait a bit to make sure the theme is loaded
ok

###############################################################################
# Kill affected applications                                                  #
###############################################################################
bot "OK. Note that some of these changes require a logout/restart to take effect. Killing affected applications (so they can reboot)...."

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Google Chrome" "Mail" "Messages" "Photos" "Safari" "Transmission" "Xcode" "Twitter" "Tweetbot" "SystemUIServer" \
  "VLC" "Karabiner-Menu" "Spotify" "Code" "iTerm2" "Arduino"; do
  killall "${app}" >/dev/null 2>&1
done

running "Do a last minute check and cleanup routine"
brew update && brew upgrade && brew cleanup

bot "Woot! All done"
killall "Terminal" >/dev/null 2>&1
