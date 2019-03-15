# \\[._.]/ - Hi, I'm the MacOS bot

I will update your MacOS machine with Better™ system defaults, preferences, software configuration and even auto-install some handy development tools and apps that my developer friends find helpful.

You don't need to install or configure anything upfront! This works with a brand-new machine from the factory as well as an existing machine that you've been working with for years.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Forget About Manual Configuration!](#forget-about-manual-configuration)
- [Watch me run!](#watch-me-run)
- [Installation](#installation)
  - [Restoring Dotfiles](#restoring-dotfiles)
- [Additional](#additional)
  - [VIM as IDE](#vim-as-ide)
- [Settings](#settings)
	- [Security](#security)
  - [SSD-specific tweaks](#ssd-specific-tweaks)
  - [Optional / Experimental](#optional--experimental)
  - [General System Changes](#general-system-changes)
  - [Trackpad, mouse, keyboard, Bluetooth accessories, and input](#trackpad-mouse-keyboard-bluetooth-accessories-and-input)
  - [Configuring the Screen](#configuring-the-screen)
  - [Finder Configs](#finder-configs)
  - [Dock & Dashboard](#dock--dashboard)
  - [Safari & WebKit](#safari--webkit)
  - [Mail](#mail)
  - [Spotlight](#spotlight)
  - [Time Machine](#time-machine)
  - [Activity Monitor](#activity-monitor)
  - [Address Book, Dashboard, iCal, TextEdit, and Disk Utility](#address-book-dashboard-ical-textedit-and-disk-utility)
  - [Mac App Store](#mac-app-store)
  - [Messages](#messages)
  - [Sublime Text](#sublime-text)
  - [Transmission](#transmission)
  - [Xcode](#xcode)
  - [VLC](#vlc)
  - [Karabiner Elements](#karabiner-elements)
  - [Visual Studio Code](#visual-studio-code)
  - [Arduino IDE](#arduino-ide)
  - [Jetbrains Apps](#jetbrains-apps)
  - [Terminal & iTerm2](#terminal--iterm2)
- [Software Installation](#software-installation)
  - [Utilities](#utilities)
  - [Apps](#apps)
  - [Ruby Gems](#ruby-gems)
  - [Npm](#npm)
- [License](#license)
- [Contributions](#contributions)
- [Loathing, Mehs and Praise](#loathing-mehs-and-praise)
- [¯\\_(ツ)_/¯ Warning / Liability](#%C2%AF%5C%5C_%E3%83%84_%C2%AF-warning--liability)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Forget About Manual Configuration!

Don't you hate getting a new laptop or joining a new team and then spending a whole day setting up your system preferences and tools? Me too. That's why we automate; we did it once and we don't want to do have to do it again.

\\[^_^]/ - This started as [Adam Eivy](http://adameivy.com)'s MacOS shell configuration dotfiles but has grown to a multi-developer platform for machine configuration.

When I finish with your machine, you will be able to look at your command-line in full-screen mode like this (running iTerm):

![iTerm Screenshot](https://raw.githubusercontent.com/STiXzoOR/dotfiles/master/img/term.png)

Check out how your shell prompt includes the full path, node.js version & the working git branch along with a lot of other info!
We use powerlevel9k for command prompt, so customization of what you want is easily changable in `./.zpowerlevel9k_config`
The top terminal is using vim as a full replacement IDE.
The bottom left two are git terminals.
The bottom right is running `vtop`

To launch fullscreen, hit `Command + Enter` in iTerm, then use `Command + d` and `Command + D` to create split panes.


\\[._.]/ - I'm so excited I just binaried in my pants!

# Watch me run!
![Running](http://media.giphy.com/media/5xtDarwenxEoFeIMEM0/giphy.gif)

# Installation

> Note: I recommend forking this repo in case you don't like anything I do and want to set your own preferences (and pull request them!)

> REVIEW WHAT THIS SCRIPT DOES PRIOR TO RUNNING: https://github.com/STiXzoOR/dotfiles/blob/master/install.sh#L275-L1038
> It's always a good idea to review arbitrary code from the internet before running it on your machine with sudo power!
> You are responsible for everything this script does to your machine (see LICENSE)

```
$ git clone --recurse-submodules https://github.com/STiXzoOR/dotfiles ~/.dotfiles
$ cd ~/.dotfiles;
# run this using terminal (not iTerm, last iTerm settings get discarded on exit)
$ ./install.sh
```
* When it finishes, open iTerm and press `Command + ,` to open preferences. Under Profiles > Colors, select "Load Presets" and choose the `Dracula` scheme. If it isn't there for some reason, import it from `~/.dotfiles/configs/itemr2` -- you may also need to select the `Meslo LG MD Z for Powerline` font and check the box for non-ascii font and set to `Hack Nerd`
* I've also found that you need to reboot before fast key repeat will be enabled

> Note: running install.sh is idempotent. You can run it again and again as you add new features or software to the scripts! I'll regularly add new configurations so keep an eye on this repo as it grows and optimizes.

## Restoring Dotfiles

If you have existing dotfiles for configuring git, zsh, vim, etc, these will be backed-up into `~/.dotfiles_backup/$(date +"%Y.%m.%d.%H.%M.%S")` and replaced with the files from this project. You can restore your original dotfiles by using `./restore.sh $RESTOREDATE` where `$RESTOREDATE` is the date folder name you want to restore.

> The restore script does not currently restore system settings--only your original dotfiles. To restore system settings, you'll need to manually undo what you don't like (so don't forget to fork, review, tweak)

# Additional

## VIM as IDE
I am using `vim` as my IDE. I use Vundle to manage vim plugins (instead of pathogen). Vundle is better in many ways and is compatible with pathogen plugins. Additionally, vundle will manage and install its own plugins so we don't have to use git submodules for all of them.

# Settings
This project changes a number of settings and configures software on MacOS.
Here is the current list:

## Prompt Driven Configuration
The following will only happen if you agree on the prompt
- overwrite your /etc/hosts file with a copy from someonewhocares.org (see ./configs/hosts for the file that will be used)
- update github configuration
- replace the system wallpaper with `img/wallpaper.heic`
- link dotfiles
- install vim plugins/themes
- install fonts
- change system configuration

## Security
- Enable install from Anywhere
- Disable remote apple events
- Disable remote login
- Disable wake-on modem
- Disable wake-on LAN
- Disable guest account login
- Disable the “Are you sure you want to open this application?” dialog

## SSD-specific tweaks
- Disable local Time Machine snapshots
- Disable hibernation (speeds up entering sleep mode)
- Remove the sleep image file to save disk space

## Optional / Experimental
- Set computer name (as done via System Preferences → Sharing)
- Disable Resume system-wide
- Show icons for hard drives, servers, and removable media on the desktop

## General System Changes
- Set standby delay to 24 hours (default is 1 hour)
- Set highlight color to green
- Set sidebar icon size to medium
- Always show scrollbars
- Increase window resize speed for Cocoa applications
- Expand save panel by default
- Expand print panel by default
- Save to disk (not to iCloud) by default
- Automatically quit printer app once the print jobs complete
- Disable the “Are you sure you want to open this application?” dialog
- Disable automatic termination of inactive apps
- Set Help Viewer windows to non-floating mode
- Reveal IP, hostname, OS, etc. when clicking clock in login window
- Restart automatically if the computer freezes
- Check for software updates daily, not just once per week
- Disable smart quotes as they’re annoying when typing code
- Disable smart dashes as they’re annoying when typing code

## Trackpad, mouse, keyboard, Bluetooth accessories, and input
- Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
- Disable press-and-hold for keys in favor of key repeat
- Set a blazingly fast keyboard repeat rate
- Show language menu in the top right corner of the boot screen
- Set timezone to Europe/Athens;
- Disable auto-correct

## Configuring the Screen
- Require password immediately after sleep or screen saver begins
- Save screenshots to the desktop
- Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
- Disable shadow in screenshots
- Enable subpixel font rendering on non-Apple LCDs
- Enable HiDPI display modes (requires restart)

## Finder Configs
- Allow quitting via ⌘ + Q; doing so will also hide desktop icons
- Disable window animations and Get Info animations
- Set Desktop as the default location for new Finder windows
- Show hidden files by default
- Show all filename extensions
- Show status bar
- Show path bar
- Allow text selection in Quick Look
- When performing a search, search the current folder by default
- Disable the warning when changing a file extension
- Enable spring loading for directories
- Remove the spring loading delay for directories
- Avoid creating .DS_Store files on network volumes
- Disable disk image verification
- Automatically open a new Finder window when a volume is mounted
- Use column list view in all Finder windows by default
- Use sort by Application in all Finder windows by default
- Disable the warning before emptying the Trash
- Empty Trash securely by default
- Show the ~/Library folder
- Expand the following File Info panes: “General”, “Open with”, and “Sharing & Permissions”

## Dock & Dashboard
- Set the icon size of Dock items to 36 pixels
- Change minimize/maximize window effect to scale
- Enable magnification
- Minimize windows into their application’s icon
- Enable spring loading for all Dock items
- Show indicator lights for open applications in the Dock
- Speed up Mission Control animations
- Disable Dashboard
- Don’t show Dashboard as a Space
- Remove the auto-hiding Dock delay
- Make Dock icons of hidden applications translucent

## Safari & WebKit
- Set Safari’s home page to ‘about:blank’ for faster loading
- Prevent Safari from opening ‘safe’ files automatically after downloading
- Allow hitting the Backspace key to go to the previous page in history
- Hide Safari’s bookmarks bar by default
- Hide Safari’s sidebar in Top Sites
- Disable Safari’s thumbnail cache for History and Top Sites
- Enable Safari’s debug menu
- Make Safari’s search banners default to Contains instead of Starts With
- Remove useless icons from Safari’s bookmarks bar
- Enable the Develop menu and the Web Inspector in Safari
- Add a context menu item for showing the Web Inspector in web views
- Warn about fraudulent websites
- Block pop-up windows
- Enable Do Not Track
- Update extensions automatically
- Don’t send search queries to Apple

## Mail
- Disable send and reply animations in Mail.app
- Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app
- Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
- Display emails in threaded mode, sorted by date (oldest at the top)
- Disable inline attachments (just show the icons)
- Disable automatic spell checking

## Spotlight
- Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed
- Change indexing order and disable some file types from being indexed
- Load new settings before rebuilding the index
- Make sure indexing is enabled for the main volume

## Time Machine
- Prevent Time Machine from prompting to use new hard drives as backup volume
- Disable local Time Machine backups

## Activity Monitor
- Show the main window when launching Activity Monitor
- Visualize CPU usage in the Activity Monitor Dock icon
- Show all processes in Activity Monitor
- Sort Activity Monitor results by CPU usage

## Address Book, Dashboard, iCal, TextEdit, and Disk Utility
- Enable the debug menu in Address Book
- Enable Dashboard dev mode (allows keeping widgets on the desktop)
- Use plain text mode for new TextEdit documents
- Open and save files as UTF-8 in TextEdit
- Enable the debug menu in Disk Utility

## Mac App Store
- Enable the WebKit Developer Tools in the Mac App Store
- Enable Debug Menu in the Mac App Store

## Messages
- Disable automatic emoji substitution (i.e. use plain text smileys)
- Disable smart quotes as it’s annoying for messages that contain code
- Disable continuous spell checking

## Sublime Text
- Install dracula theme
- Install settings
- Install addon(s) settings

## Transmission
- Use ~/Documents/Torrents to store incomplete downloads
- Use ~/Downloads to store completed downloads
- Don’t prompt for confirmation before downloading
- Don’t prompt for confirmation before removing non-downloading active transfers
- Trash original torrent files
- Enabling queue
- Setting queue maximum downloads
- Hide the donate message
- Hide the legal disclaimer
- Setting IP block list
- Randomize port on launch

## Xcode
- Change theme to Dracula
- Trim trailing whitespace
- Trim whitespace only lines
- Show line numbers
- Reduce the number of compile tasks and stop indexing
- Show all devices and their information you have plugged in before
- Show ruler at 80 chars
- Map ⌃⌘L to show last change for the current line
- Show build time
- Improve performance
- Improve performance by leveraging multi-core CPU
- Delete these settings

## VLC
- Install settings

## Karabiner Elements
- Install settings

## Visual Studio Code
- Install extensions
- Install settings

## Arduino IDE
- Change theme to dracula

## Jetbrains Apps
- Install dracula theme
- Install plugins
- Install settings

## Terminal & iTerm2
- Only use UTF-8 in Terminal.app
- Use dracula theme by default in Terminal.app
- Install custom solarized dark theme in Terminal.app
- Enable “focus follows mouse” for Terminal.app and all X11 apps
- Tell iTerm2 to use the custom preferences in the directory
- Specify the preferences directory
- Install the dracula theme for iTerm (opening file)
- Install the patched solarized dark theme for iTerm (opening file)

# Software Installation

homebrew, fontconfig, git, ruby (latest), nvm (node + npm), and zsh (latest) are all installed inside the `install.sh` as foundational software for running this project.
Additional software is configured in `config.js` and can be customized in your own fork/branch (you can change everything in your own fork/brance).
The following is the software that I have set as default:

## Utilities

* ack
* ag
* bat
* coreutils
* dos2unix
* dpkg
* exa
* findutils
* fortune
* fzf
* readline
* gawk
* gifsicle
* gnupg
* gnu-sed --with-default-names
* grep --with-default-names
* homebrew/dupes/grep
* httpie
* jq
* mas
* moreutils
* neofetch
* nmap
* openconnect
* reattach-to-user-namespace
* homebrew/dupes/screen
* tmux
* todo-txt
* tree
* ttyrec
* vim --with-client-server --with-override-system-vi
* watch
* wget --enable-iri

## Apps

* adobe-creative-cloud
* android-file-transfer
* android-studio
* arduino
* clover-configurator
* coconutbattery
* darwindumper
* discord
* dropbox
* flux
* fritzing
* github
* google-chrome
* ifunbox
* iina
* intel-power-gadget
* iterm2
* java8
* jdownloader
* karabiner-elements
* keka
* megasync
* no-ip-duc
* openemu
* pycharm-ce
* sketchup
* skype
* spotify
* stremio
* sublime-text
* teamviewer
* telegram
* torbrowser
* transmission
* tunnelblick
* ultimaker-cura
* vlc
* visual-studio-code

## Ruby Gems

* colorls

## Npm

* antic
* buzzphrase
* eslint
* instant-markdown-d
* npm-check-updates
* prettyjson
* trash
* vtop

# License
This project is licensed under ISC. Please fork, contribute and share.

# Contributions
Contributions are always welcome in the form of pull requests with explanatory comments.

Please refer to the [Contributor Covenant](https://github.com/STiXzoOR/dotfiles/blob/master/CODE_OF_CONDUCT.md)

# Loathing, Mehs and Praise
1. Loathing should be directed into pull requests that make it better. woot.
2. Bugs with the setup should be put as GitHub issues.
3. Mehs should be > /dev/null
4. Praise should be directed to ![@antic](https://img.shields.io/twitter/follow/antic.svg?style=social&label=@antic)


# ¯\\_(ツ)_/¯ Warning / Liability
> Warning:
The creator of this repo is not responsible if your machine ends up in a state you are not happy with. If you are concerned, look at the code to review everything this will do to your machine :)
