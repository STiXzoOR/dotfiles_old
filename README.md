# \\[._.]/ - Hi, I'm the MacOS bot

I will update your MacOS machine with Better™ system defaults, preferences, software configuration and even auto-install some handy development tools and apps that my developer friends find helpful.

You don't need to install or configure anything upfront! This works with a brand-new machine from the factory as well as an existing machine that you've been working with for years.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [\\[.\_.]/ - Hi, I'm the MacOS bot](#_---hi-im-the-macos-bot)
- [Forget About Manual Configuration!](#forget-about-manual-configuration)
- [Watch me run!](#watch-me-run)
- [Installation](#installation)
  - [Restoring Dotfiles](#restoring-dotfiles)
- [Additional](#additional)
  - [VIM as IDE](#vim-as-ide)
- [Settings](#settings)
  - [Prompt Driven Configuration](#prompt-driven-configuration)
  - [Security](#security)
  - [General UI/UX](#general-uiux)
  - [Trackpad, mouse, keyboard, Bluetooth accessories, and input](#trackpad-mouse-keyboard-bluetooth-accessories-and-input)
  - [Energy saving](#energy-saving)
  - [Screen](#screen)
  - [Finder](#finder)
  - [Dock & Dashboard](#dock--dashboard)
  - [Hot corners](#hot-corners)
  - [Safari & WebKit](#safari--webkit)
  - [Mail](#mail)
  - [Spotlight](#spotlight)
  - [Time Machine](#time-machine)
  - [Activity Monitor](#activity-monitor)
  - [Address Book, Dashboard, iCal, TextEdit, and Disk Utility](#address-book-dashboard-ical-textedit-and-disk-utility)
  - [Mac App Store](#mac-app-store)
  - [Photos](#photos)
  - [Messages](#messages)
  - [Transmission](#transmission)
  - [Xcode](#xcode)
  - [Twitter](#twitter)
  - [Tweetbot](#tweetbot)
  - [VLC](#vlc)
  - [Spotify](#spotify)
  - [Karabiner Elements](#karabiner-elements)
  - [Visual Studio Code](#visual-studio-code)
  - [Arduino IDE](#arduino-ide)
  - [ColorLS](#colorls)
  - [Terminal & iTerm2](#terminal--iterm2)
- [Software Installation](#software-installation)
  - [Utilities](#utilities)
  - [Apps](#apps)
  - [Ruby Gems](#ruby-gems)
  - [App Store](#app-store)
  - [Node Packages](#node-packages)
- [License](#license)
- [Contributions](#contributions)
- [Loathing, Mehs and Praise](#loathing-mehs-and-praise)
- [¯\\_(ツ)_/¯ Warning / Liability](#ツ-warning--liability)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Forget About Manual Configuration

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

## Watch me run

![Running](http://media.giphy.com/media/5xtDarwenxEoFeIMEM0/giphy.gif)

## Installation

> Note: I recommend forking this repo in case you don't like anything I do and want to set your own preferences (and pull request them!)
>
> REVIEW WHAT THIS SCRIPT DOES PRIOR TO RUNNING: [install.sh](https://github.com/STiXzoOR/dotfiles/blob/master/install.sh#L360-L1672)
>
> It's always a good idea to review arbitrary code from the internet before running it on your machine with sudo power!
> You are responsible for everything this script does to your machine (see LICENSE)

```(shell)
$ git clone --recurse-submodules https://github.com/STiXzoOR/dotfiles ~/.dotfiles
$ cd ~/.dotfiles;

# run this using terminal (not iTerm, last iTerm settings get discarded on exit)
$ ./install.sh
```

> Note: running install.sh is idempotent. You can run it again and again as you add new features or software to the scripts! I'll regularly add new configurations so keep an eye on this repo as it grows and optimizes.

## Restoring Dotfiles

If you have existing dotfiles for configuring git, zsh, vim, etc, these will be backed-up into `~/.dotfiles_backup/$(date +"%Y.%m.%d.%H.%M.%S")` and replaced with the files from this project. You can restore your original dotfiles by using `./restore.sh $RESTOREDATE` where `$RESTOREDATE` is the date folder name you want to restore.

> The restore script does not currently restore system settings--only your original dotfiles. To restore system settings, you'll need to manually undo what you don't like (so don't forget to fork, review, tweak)

## Additional

### VIM as IDE

I am using `vim` as my IDE. I use Vundle to manage vim plugins (instead of pathogen). Vundle is better in many ways and is compatible with pathogen plugins. Additionally, vundle will manage and install its own plugins so we don't have to use git submodules for all of them.

## Settings

This project changes a number of settings and configures software on MacOS.
Here is the current list:

### Prompt Driven Configuration

The following will only happen if you agree on the prompt

- overwrite your /etc/hosts file with a copy from someonewhocares.org (see ./configs/hosts for the file that will be used)
- update github configuration
- replace the system wallpaper with `img/wallpaper.heic`
- link dotfiles
- install vim plugins/themes
- install fonts
- change system configuration

### Security

- Enable install from Anywhere
- Disable remote apple events
- Disable remote login
- Disable wake-on modem
- Disable wake-on LAN
- Disable guest account login

### General UI/UX

- Set computer name (as done via System Preferences → Sharing)
- Disable the sound effects on boot
- Set highlight color to steel blue
- Set sidebar icon size to medium
- Always show scrollbars
- Disable the over-the-top focus ring animation
- Adjust toolbar title rollover delay
- Increase window resize speed for Cocoa applications
- Expand save panel by default
- Expand print panel by default
- Save to disk (not to iCloud) by default
- Automatically quit printer app once the print jobs complete
- Disable the “Are you sure you want to open this application?” dialog
- Remove duplicates in the “Open With” menu (also see 'lscleanup' alias)
- Display ASCII control characters using caret notation in standard text views
- Disable Resume system-wide
- Disable automatic termination of inactive apps
- Set Help Viewer windows to non-floating mode
- Reveal IP, hostname, OS, etc. when clicking clock in login window
- Disable automatic capitalization as it’s annoying when typing code
- Disable smart dashes as they’re annoying when typing code
- Disable automatic period substitution as it’s annoying when typing code
- Disable smart quotes as they’re annoying when typing code
- Disable auto-correct

### Trackpad, mouse, keyboard, Bluetooth accessories, and input

- Increase sound quality for Bluetooth headphones/headsets
- Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
- Disable press-and-hold for keys in favor of key repeat
- Set a blazingly fast keyboard repeat rate
- Set language and text formats (english/GR)
- Show language menu in the top right corner of the boot screen
- Set timezone to Europe/Athens;

### Energy saving

- Disable lid wakeup
- Disable auto power off
- Disable auto restart on power loss
- Disable machine sleep
- Sleep the display after 60 minutes
- Disable standby mode
- Set standby delay to 24 hours (default is 1 hour)
- Disable wake from iPhone/Watch (eg. When iPhone or Apple Watch come near)
- Disable periodically wake of machine for network and updates
- Restart automatically if the computer freezes
- Disable hibernation (speeds up entering sleep mode)
- Remove the sleep image file to save disk space
- Create a zero-byte file instead…
- …and make sure it can’t be rewritten

### Screen

- Require password immediately after sleep or screen saver begins
- Save screenshots to the desktop
- Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
- Disable shadow in screenshots
- Enable subpixel font rendering on non-Apple LCDs
- Enable HiDPI display modes (requires restart)

### Finder

- Allow quitting via ⌘ + Q; doing so will also hide desktop icons
- Disable window animations and Get Info animations
- Set Desktop as the default location for new Finder windows
- Show icons for hard drives, servers, and removable media on the desktop
- Show hidden files by default
- Show all filename extensions
- Show status bar
- Show path bar
- Keep folders on top when sorting by name
- When performing a search, search the current folder by default
- Disable the warning when changing a file extension
- Enable spring loading for directories
- Remove the spring loading delay for directories
- Avoid creating .DS_Store files on network or USB volumes
- Disable disk image verification
- Automatically open a new Finder window when a volume is mounted
- Show item info near icons on the desktop and in other icon views
- Show item info to the right of the icons on the desktop
- Enable snap-to-grid for icons on the desktop and in other icon views
- Increase grid spacing for icons on the desktop and in other icon views
- Increase the size of icons on the desktop and in other icon views
- Use column list view in all Finder windows by default
- Use sort by Application in all Finder windows by default
- Disable the warning before emptying the Trash
- Empty Trash securely by default
- Show the ~/Library folder
- Show the /Volumes folder
- Expand the following File Info panes: “General”, “Open with”, and “Sharing & Permissions”

### Dock & Dashboard

- Set the icon size of Dock items to 36 pixels
- Change minimize/maximize window effect to scale
- Enable magnification
- Minimize windows into their application’s icon
- Enable spring loading for all Dock items
- Show indicator lights for open applications in the Dock
- Speed up Mission Control animations
- Remove the auto-hiding Dock delay
- Make Dock icons of hidden applications translucent
- Reset Launchpad, but keep the desktop wallpaper intact
- Add iOS & Watch Simulator to Launchpad

### Hot corners

- Top left screen corner → Mission Control
- Top right screen corner → Desktop
- Bottom left screen corner → Start screen saver

### Safari & WebKit

- Don’t send search queries to Apple
- Press Tab to highlight each item on a web page
- Show the full URL in the address bar (note: this still hides the scheme)
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
- Enable continuous spellchecking
- Disable auto-correct
- Disable AutoFill
- Warn about fraudulent websites
- Disable plug-ins
- Disable Java
- Block pop-up windows
- Enable Do Not Track
- Update extensions automatically

### Mail

- Disable send and reply animations in Mail.app
- Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app
- Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
- Display emails in threaded mode, sorted by date (oldest at the top)
- Disable inline attachments (just show the icons)
- Disable automatic spell checking

### Spotlight

- Change indexing order and disable some file types from being indexed
- Load new settings before rebuilding the index
- Make sure indexing is enabled for the main volume
- Rebuild the index from scratch

### Time Machine

- Prevent Time Machine from prompting to use new hard drives as backup volume
- Disable local Time Machine backups

### Activity Monitor

- Show the main window when launching Activity Monitor
- Visualize CPU usage in the Activity Monitor Dock icon
- Show all processes in Activity Monitor
- Sort Activity Monitor results by CPU usage
- Set columns for each tab
- Sort columns in each tab
- Update refresh frequency (in seconds)
- Show Data in the Disk graph (instead of IO)
- Show Data in the Network graph (instead of packets)
- Change Dock Icon

### Address Book, Dashboard, iCal, TextEdit, and Disk Utility

- Enable the debug menu in Address Book
- Enable Dashboard dev mode (allows keeping widgets on the desktop)
- Use plain text mode for new TextEdit documents
- Open and save files as UTF-8 in TextEdit
- Enable the debug menu in Disk Utility
- Auto-play videos when opened with QuickTime Player

### Mac App Store

- Enable the WebKit Developer Tools in the Mac App Store
- Enable Debug Menu in the Mac App Store
- Enable the automatic update check
- Check for software updates daily, not just once per week
- Automatically download apps purchased on other Macs
- Turn on app auto-update

### Photos

- Prevent Photos from opening automatically when devices are plugged in

### Messages

- Disable automatic emoji substitution (i.e. use plain text smileys)
- Disable smart quotes as it’s annoying for messages that contain code
- Disable continuous spell checking
- Disable the all too sensitive backswipe on trackpads
- Disable the all too sensitive backswipe on Magic Mouse
- Use the system-native print preview dialog
- Expand the print dialog by default

### Transmission

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

### Xcode

- Create xcode custom theme folder
- Install dracula theme
- Install nord theme
- Change theme to nord
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

### Twitter

- Disable smart quotes as it’s annoying for code tweets
- Show the app window when clicking the menu bar icon
- Enable the hidden ‘Develop’ menu
- Open links in the background
- Allow closing the ‘new tweet’ window by pressing $(Esc)
- Show full names rather than Twitter handles
- Hide the app in the background if it’s not the front-most window

### Tweetbot

- Bypass the annoyingly slow t.co URL shortener

### VLC

- Install settings

### Spotify

- Install spotifyd settings
- Install spicetify settings
- Install spicetify themes
- Change theme to nord

### Karabiner Elements

- Install settings

### Visual Studio Code

- Install extensions
- Install settings

### Arduino IDE

- Change theme to dracula

### ColorLS

- Install dracula colors

### Terminal & iTerm2

- Only use UTF-8 in Terminal.app
- Install dracula theme in Terminal.app
- Install nord theme in Terminal.app
- Use nord theme by default in Terminal.app
- Enable “focus follows mouse” for Terminal.app and all X11 apps
- Tell iTerm2 to use the custom preferences in the directory
- Specify the preferences directory
- Install dracula theme for iTerm (opening file)
- Install nord theme for iTerm (opening file)

## Software Installation

homebrew, fontconfig, git, ruby (latest), nvm (node + npm), and zsh (latest) are all installed inside the `install.sh` as foundational software for running this project.
Additional software is configured in `config.js` and can be customized in your own fork/branch (you can change everything in your own fork/brance).
The following is the software that I have set as default:

### Utilities

- Ack
- Ag
- Bat
- Coreutils
- Delta
- Dos2Unix
- Dpkg
- Exa
- Findutils
- Fortune
- Fselect
- Fzf
- Gawk
- Gifsicle
- Gnupg
- Gnu Sed
- Grep
- Homebrew/Dupes/Grep
- Httpie
- Jq
- Mas
- Mongodb Community
- Moreutils
- Mysql
- Ncurses
- Neofetch
- Nmap
- Node
- Openconnect
- Python
- Python Tk
- Readline
- Reattach To User Namespace
- Srkomodo/Tap/Shadowfox Updater
- Homebrew/Dupes/Screen
- Spicetify Cli
- Spotify Tui
- Spotifyd
- Svn
- Tldr
- Tmux
- Todo Txt
- Tree
- Ttyrec
- Vim
- Watch
- Wget
- Youtube Dl

### Apps

- Adobe Creative Cloud
- Aerial
- Altserver
- Android File Transfer
- Android Platform Tools
- Android Studio
- Arduino
- Autodesk Fusion360
- Balenaetcher
- Barrier
- Brave Browser
- Caprine
- Checkra1N
- Coconutbattery
- Darwindumper
- Discord
- Electorrent
- Figma
- Firefox
- Flux
- Fritzing
- Github
- Google Backup And Sync
- Google Chrome
- Hackintool
- Iina
- Intel Power Gadget
- Iterm2
- Java
- Karabiner Elements
- Keka
- Macupdater
- Mamp
- Mongodb Compass
- Monitorcontrol
- Mos
- Mysqlworkbench
- Open In Code
- Sketchup
- Spotify
- Surfshark
- Teamviewer
- Telegram
- Transmission
- Tunnelblick
- Ukelele
- Ultimaker Cura
- Virtualbox
- Virtualbox Extension Pack
- Visual Studio Code
- Vlc

### App Store

- Microsoft Remote Desktop
- Paste
- Trello
- Magnet
- LastPass
- Spark
- Twitter
- Messenger
- Emby

### Node Packages

- Antic
- Buzzphrase
- Eslint
- Instant Markdown D
- Gulp Cli
- Npm Check Updates
- Prettier
- Prettyjson
- Trash
- Vtop
- Webtorrent Cli

## License

This project is licensed under ISC. Please fork, contribute and share.

## Contributions

Contributions are always welcome in the form of pull requests with explanatory comments.

Please refer to the [Contributor Covenant](https://github.com/STiXzoOR/dotfiles/blob/master/CODE_OF_CONDUCT.md)

## Loathing, Mehs and Praise

1. Loathing should be directed into pull requests that make it better. woot.
2. Bugs with the setup should be put as GitHub issues.
3. Mehs should be > /dev/null
4. Praise should be directed to ![@antic](https://img.shields.io/twitter/follow/antic.svg?style=social&label=@antic)

## ¯\\_(ツ)_/¯ Warning / Liability

> Warning:
> The creator of this repo is not responsible if your machine ends up in a state you are not happy with. If you are concerned, look at the code to review everything this will do to your machine :)
