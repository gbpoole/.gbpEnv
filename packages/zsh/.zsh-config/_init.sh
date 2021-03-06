#!/usr/bin/env zsh
# vim:syntax=sh
# vim:filetype=sh

# system executables
export PATH=$PATH:/usr/bin:/bin:/usr/sbin:/sbin:/usr/libexec

# local system binaries
export PATH=/usr/local/sbin:/usr/local/bin:$PATH

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
source ${ZSHCONFIG}/antibody.zsh
source ${ZSHCONFIG}/zsh-managed-plugins.zsh

# Load all scripts ${ZSHCONFIG}/lib/*.zsh
my_zsh_lib=${ZSHCONFIG}/lib
if [[ -d "$my_zsh_lib" ]]; then
   for file in $my_zsh_lib/*.zsh; do
      source $file
   done
fi
unset my_zsh_lib

#-----------------------------------------------------
# set the PATH for macOS
# [[ -x /bin/launchctl ]] && /bin/launchctl setenv PATH $PATH
