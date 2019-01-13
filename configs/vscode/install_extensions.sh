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
"coenraads.bracket-pair-colorizer"
"davidanson.vscode-markdownlint"
"dbaeumer.vscode-eslint"
"donjayamanne.githistory"
"dracula-theme.theme-dracula"
"dsznajder.es7-react-js-snippets"
"eg2.tslint"
"eg2.vscode-npm-script"
"formulahendry.auto-close-tag"
"formulahendry.auto-rename-tag"
"jpoissonnier.vscode-styled-components"
"kumar-harsh.graphql-for-vscode"
"mechatroner.rainbow-csv"
"mikestead.dotenv"
"mrmlnc.vscode-scss"
"msjsdiag.debugger-for-chrome"
"naumovs.color-highlight"
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
