#!/usr/bin/env bash

###########################
# This script installs VSCode extensions
# @author STiXzoOR
###########################

Extensions=(
"2gua.rainbow-brackets"
"aaron-bond.better-comments"
"apollographql.vscode-apollo"
"chenxsan.vscode-standardjs"
"christian-kohler.npm-intellisense"
"christian-kohler.path-intellisense"
"CoenraadS.bracket-pair-colorizer-2"
"davidanson.vscode-markdownlint"
"dbaeumer.vscode-eslint"
"donjayamanne.githistory"
"donjayamanne.python-extension-pack"
"dracula-theme.theme-dracula"
"dsznajder.es7-react-js-snippets"
"eg2.tslint"
"eg2.vscode-npm-script"
"esbenp.prettier-vscode"
"formulahendry.auto-close-tag"
"formulahendry.auto-rename-tag"
"jpoissonnier.vscode-styled-components"
"kamikillerto.vscode-colorize"
"mechatroner.rainbow-csv"
"mikestead.dotenv"
"mrmlnc.vscode-scss"
"msjsdiag.debugger-for-chrome"
"numso.prettier-standard-vscode"
"octref.vetur"
"peterjausovec.vscode-docker"
"pflannery.vscode-versionlens"
"pkosta2005.heroku-command"
"pnp.polacode"
"prisma.vscode-graphql"
"rebornix.ruby"
"robertohuertasm.vscode-icons"
"steoates.autoimport"
"techer.open-in-browser"
"visualstudioexptteam.vscodeintellicode"
"wesbos.theme-cobalt2"
"wix.vscode-import-cost"
"xabikos.reactsnippets"
)

for name in "${Extensions[@]}"
do
	code --install-extension "$name" > /dev/null 2>&1
done
