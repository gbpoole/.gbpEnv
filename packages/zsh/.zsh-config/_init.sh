#!/usr/bin/env zsh
# vim:syntax=sh
# vim:filetype=sh

# PATH ordering is managed in shell rc files via add2path.
# Avoid mutating PATH here to prevent duplicate entries and unstable ordering.

# Make sure ZSH is calling this:
# https://stackoverflow.com/a/9911082/339302
if [ ! -n "$ZSH_VERSION" ]; then
    return
fi

# Set autoloaded functions
my_zsh_fpath=${ZSHCONFIG}/autoloaded
fpath=($my_zsh_fpath $fpath)
if [[ -d "$my_zsh_fpath" ]]; then
    for func in $my_zsh_fpath/*; do
        autoload -Uz ${func:t}
    done
fi
unset my_zsh_fpath

# Load the plugins before scripts
source ${ZSHCONFIG}/plugins.zsh

# Source all *.zsh scripts in ${ZSHCONFIG}/scripts
scripts_dir=${ZSHCONFIG}/scripts
if [[ -d "$scripts_dir" ]]; then
   for file in $scripts_dir/*.zsh; do
      source $file
   done
fi
unset scripts_dir

#-----------------------------------------------------
# set the PATH for macOS
# [[ -x /bin/launchctl ]] && /bin/launchctl setenv PATH $PATH
