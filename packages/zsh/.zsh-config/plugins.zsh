#!/usr/bin/env zsh
# vim:syntax=sh
# vim:filetype=sh

# Install ZPM in the ZSHCONFIG directory
local ZPM_DIR=${ZSHCONFIG}/zpm

# Install ZPM if it hasn't been already
if [[ ! -f ${ZPM_DIR}/zpm.zsh ]]; then
  git clone --recursive https://github.com/zpm-zsh/zpm ${ZPM_DIR}
fi

# Source ZPM
source ${ZPM_DIR}/zpm.zsh

# Load plugins
if [[ $OSTYPE = (darwin)* ]]; then
    local plugins_list=${ZSHCONFIG}/plugins-list.darwin
else
    local plugins_list=${ZSHCONFIG}/plugins-list.linux
fi
for plugin in $plugins_list; do
   zpm load $plugin
done

unset plugins_list
unset ZPM_DIR
