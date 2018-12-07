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
    'nmap',
    'openconnect',
    'reattach-to-user-namespace',
    // better/more recent version of screen
    'homebrew/dupes/screen',
    'screenfetch',
    'tmux',
    'todo-txt',
    'tree',
    'ttyrec',
    // better, more recent vim
    'vim --with-override-system-vi',
    'watch',
    // Install wget with IRI support
    'wget --enable-iri'
  ],
  cask: [
    'adobe-creative-cloud',
    'android-studio',
    'arduino',
    'clover-configurator',
    'coconutbattery',
    'darwindumper',
    'discord',
    'dropbox',
    'flux',
    'fritzing',
    'github',
    'google-chrome',
    'ifunbox',
    'intel-power-gadget',
    'iterm2',
    'java8',
    'jdownloader',
    'karabiner-elements',
    'keka',
    'megasync',
    'openemu',
    'sketchup',
    'skype',
    'spotify',
    'sublime-text',
    'teamviewer',
    'telegram',
    'torbrowser',
    'transmission',
    'tunnelblick',
    'ultimaker-cura'
    'vlc',
    //'atom',
    //'adium',
    //'amazon-cloud-drive',
    //'box-sync',
    //'comicbooklover',
    //'diffmerge',
    //'docker', // docker for mac
    //'evernote',
    //'gpg-suite',
    //'ireadfast',
    ///'little-snitch',
    //'macbreakz',
    //'micro-snitch',
    //'signal',
    //'macvim',
    //'sizeup',
    //'slack',
    //'the-unarchiver',
    //'visual-studio-code',
    //'xquartz'
  ],
  gem: [
  'colorls'
  ],
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
};
