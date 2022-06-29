#!/usr/bin/env zsh
# vim:syntax=sh
# vim:filetype=sh

# Load plugins
if [[ $OSTYPE = (darwin)* ]]; then
    local plugins_list=${ZSHCONFIG}/plugins-list.darwin
else
    local plugins_list=${ZSHCONFIG}/plugins-list.linux
fi
local plugins_list_zsh=${ZSHCONFIG}/plugins-list.zsh

# The following code is a modified version of code found here: https://getantidote.github.io

# Clone antidote if necessary and generate a static plugin file
zhome=${ZSHCONFIG}
if [[ ! $plugins_list_zsh -nt $plugins_list ]]; then
  [[ -e $zhome/.antidote ]] \
    || git clone --depth=1 https://github.com/mattmc3/antidote.git $zhome/antidote
  [[ -e $plugins_list ]] || touch $plugins_list
  (
    source $zhome/antidote/antidote.zsh
    antidote bundle <$plugins_list >$plugins_list_zsh
  )
fi

# For commands like `antidote update`
autoload -Uz $zhome/antidote/functions/antidote

# source static plugins file
source $plugins_list_zsh
unset zhome

unset plugins_list
unset plugins_list_zsh
