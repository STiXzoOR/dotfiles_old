module.exports = {
  brew: [
    // http://conqueringthecommandline.com/book/ack_ag
    'ack',
    'ag',
    // alternative to `cat`: https://github.com/sharkdp/bat
    'bat',
    // Install GNU core utilities (those that come with macOS are outdated)
    // Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
    'coreutils',
    'dos2unix',
    'dpkg',
    // colored ls
    'exa',
    // Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
    'findutils',
    'fortune',
    'fzf',
    'readline', // ensure gawk gets good readline
    'gawk',
    // http://www.lcdf.org/gifsicle/ (because I'm a gif junky)
    'gifsicle',
    'gnupg',
    // Install GNU `sed`, overwriting the built-in `sed`
    // so we can do "sed -i 's/foo/bar/' file" instead of "sed -i '' 's/foo/bar/' file"
    'gnu-sed --with-default-names',
    // upgrade grep so we can get things like inverted match (-v)
    'grep --with-default-names',
    // better, more recent grep
    'homebrew/dupes/grep',
    // https://github.com/jkbrzt/httpie
    'httpie',
    // jq is a sort of JSON grep
    'jq',
    // Mac App Store CLI: https://github.com/mas-cli/mas
    'mas',
    // Install some other useful utilities like `sponge`
    'moreutils',
    'neofetch',
    'nmap',
    'openconnect',
    'python',
    'reattach-to-user-namespace',
    // better/more recent version of screen
    'homebrew/dupes/screen',
    'tmux',
    'todo-txt',
    'tree',
    'ttyrec',
    // better, more recent vim
    'vim --with-client-server --with-override-system-vi',
    'watch',
    // Install wget with IRI support
    'wget --enable-iri',
    'webtorrent-cli',
    'youtube-dl'
  ],
  cask: [
    'adobe-creative-cloud',
    'altserver',
    'android-file-transfer',
    'android-studio',
    'arduino',
    'brave-browser',
    'clover-configurator',
    'coconutbattery',
    'darwindumper',
    'discord',
    'dropbox',
    'eclipse-java',
    'firefox',
    'flux',
    'fritzing',
    'github',
    'google-backup-and-sync',
    'google-chrome',
    'intel-power-gadget',
    'iterm2',
    'java',
    'java8',
    'jdownloader',
    'karabiner-elements',
    'keka',
    'macupdater',
    'mamp',
    'monitorcontrol',
    'mono-mdk',
    'open-in-code',
    'openemu',
    'sketchup',
    'spotify',
    'sublime-text',
    'teamviewer',
    'telegram',
    'transmission',
    'tunnelblick',
    'ukelele',
    'ultimaker-cura',
    'virtualbox',
    'virtualbox-extension-pack',
    'visual-studio-code',
    'vlc'
  ],
  gem: ['colorls'],
  npm: [
    'antic',
    'buzzphrase',
    'eslint',
    'instant-markdown-d',
    // 'generator-dockerize',
    // 'gulp',
    'npm-check-updates',
    'prettyjson',
    'trash',
    'vtop'
    // ,'yo'
  ]
}
