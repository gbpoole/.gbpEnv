#!/usr/bin/env zsh
# vim:syntax=sh
# vim:filetype=sh

local ANTIBODY=~/3rd_Party/bin/antibody

if [[ -x ${ANTIBODY} ]]; then
    if [[ $OSTYPE = (darwin)* ]]; then
        local plugins_list=${ZSHCONFIG}/zsh-antibody-plugins-list.darwin
    else
        local plugins_list=${ZSHCONFIG}/zsh-antibody-plugins-list.linux
    fi
    local managed_plugins=${ZSHCONFIG}/zsh-managed-plugins.zsh

    # Set some aliases    
    alias antibody.list=${ANTIBODY}' list'
    alias antibody.update=${ANTIBODY}' update'
    alias antibody.home=${ANTIBODY}' home'
    alias antibody.clean='rm -rf `antibody.home`'
    alias antibody.reset='antibody.clean && antibody.install'

    function antibody.install(){
        echo 'Installing plugins ... '
        # Needed for oh-my-zsh ... see: https://github.com/getantibody/antibody/issues/218
        ZSH=`antibody.home`"/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
        ${ANTIBODY} bundle < ${plugins_list} > ${managed_plugins}
        echo 'Done!'
    }
    
    function antibody.purge(){
        if [[ ! -z "$1" ]]; then
           ${ANTIBODY} purge $1
        fi
    }
    
    # Make sure plugin directory exists and plugins are installed
    if [[ ! -d `antibody.home` ]]; then
        echo 'Creating antibody directory: '`antibody.home`
        mkdir `antibody.home`
        if [[ ! -d `antibody.home` ]]; then
            echo 'Failed.  Could not configure antibody.'
        else
            antibody.install
        fi
    fi
else
    echo 'Antibody not installed; plugins could not be started.  Please run `make antibody` in ${GBP_HOME}/3rd_Party'
fi
