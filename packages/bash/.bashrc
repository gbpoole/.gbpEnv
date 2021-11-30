#!/bin/bash
# vim:syntax=sh
# vim:filetype=sh

# If we're running tests, then exit with failure upon any error
if [ -n "$GBPENV_TEST" ] ; then
    set -e
fi

# Set-up some generic UNIX stuff
umask 22
ulimit -c 0
unset autologout

# It is possible to configure this environment somewhere
# other than the home directory.  This is useful when you
# want the configuration here to be applied in a shared-account
# situation.  Set the path to the install here.
if [ ! -f "${GBP_HOME}/.bashrc.system" ]; then
    if [ -f ${PWD}/.bashrc ]; then
       export GBP_HOME=${PWD}
    else
       export GBP_HOME=${HOME}
    fi
fi

# Set autoloaded functions
my_autoload_path=${GBP_HOME}/bin/autoload
fpath=($my_autoload_path $fpath)
if [[ -d "$my_autoload_path" ]]; then
    for func in $my_autoload_path/*; do
        # zsh does things this way
        if [ -n "$ZSH_VERSION" ]; then
            autoload -Uz ${func:t}
        # autoload is not available under bash.  Do this instead.
        else
            func_filename=`basename $func`
            . $func
            export -f $func_filename
        fi
    done
fi
unset my_autoload_path

# Make sure the REMOTEHOST variable is set
if [ -z $REMOTEHOST ]; then
   export REMOTEHOST=$HOST
fi

# Make sure the DISPLAY variable is set
if [ -z $DISPLAY ]  && [ -n $REMOTEHOST ]; then
   export DISPLAY=$REMOTEHOST:0.0
fi

# Make sure /usr/local/bin is in the PATH
add2path -q /usr/local/bin

# Source the gbpDocker environment
# variable file (if present)
if [ -e ".env.gbpDocker" ]; then
    for l in ".env.gbpDocker"; do eval $(awk '{print "export "$1}' $l) ;  done
fi

# Set all system-specific stuff
source ${GBP_HOME}/.bashrc.system

# Run all remote interactive shells in tmux
if [[ ! $GBP_OS = 'Mac' ]]; then
    TMUX_CMD="tmux"
    TMUX_DEFAULT_SESSION="default"
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        if tmux has-session -t $TMUX_DEFAULT_SESSION 2>/dev/null; then
            ${TMUX_CMD} -2 attach-session -t $TMUX_DEFAULT_SESSION
        else
            ${TMUX_CMD} -2 new-session -s $TMUX_DEFAULT_SESSION
        fi
    fi
fi

# Set default editor
export EDITOR=`which vim`
if [ ! -f "${EDITOR}" ]; then
    export EDITOR=`which vi`
fi

# Add scripts to the executable to the PATH
add2path -q -f ${GBP_HOME}/bin/scripts

# Add 3rd_Party binary directory to the PATH
add2path -q -f ${GBP_HOME}/3rd_Party/bin

# Add my_code binary directory to the PATH
add2path -q -f ${GBP_HOME}/my_code/bin

# Configure Perl
export PERL_LOCAL_LIB_ROOT=${GBP_HOME}/.perl5
export PATH=${PERL_LOCAL_LIB_ROOT}/bin:$PATH
export PERL5LIB=${PERL_LOCAL_LIB_ROOT}/lib/perl5:$PERL5LIB
export PERL_MB_OPT="--install_base \"${PERL_LOCAL_LIB_ROOT}\""
export PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}"

## Configure Python - Start ##

## Set 'default' Anaconda environment
## This needs to be after the autoload functions are loaded
#if type conda.load > /dev/null 2>&1; then
#  conda.load default
#fi

# Init pyenv
add2path -q -f ${GBP_HOME}/.pyenv/shims
export PYENV_HOOK_PATH=${GBP_HOME}/.config/pyenv/pyenv.d/
export PYENV_DEFAULT_ENV='default'
if type pyenv > /dev/null 2>&1; then
   eval "$(pyenv init -)"
   if ! pyenv activate ${PYENV_DEFAULT_ENV} > /dev/null 2>&1; then
      echo 'Default pyenv environment {'$PYENV_DEFAULT_ENV'} could not be activated.'
   fi
fi

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$GBP_HOME/.pip/cache

# Add path for Poetry
add2path -q -f ${GBP_HOME}/.local/bin/

## Configure Python - End ##

# Create aliases
source ${GBP_HOME}/.alias.bash

# Set the filename for the global Matplotlib config
export MATPLOTLIBRC=${GBP_HOME}/.config/matplotlib/matplotlibrc

# Added by travis gem
if [ -f ${GBP_HOME}/.travis/travis.sh ]; then
    source ${GBP_HOME}/.travis/travis.sh
fi

# Set the prompt (if setprompt is defined; generally not if we're not in zsh)
# 'setprompt' is set as an alias in .alias.bash
if [ -n "$ZSH_VERSION" ]; then
    if [ ! `alias | grep "setprompt" | wc -l` = 0 ]; then
        setprompt
    fi
else
    if [ `type -t setprompt` ]; then
        setprompt
    fi
fi

# Set the verion of Node.js that we will use
export GBP_NODE_VERSION=14.17.0
if [ -f ${GBP_HOME}/3rd_Party/node-v${GBP_NODE_VERSION}-linux-x64/bin/node ]; then
    export NODEJS_HOME=${GBP_HOME}/3rd_Party/node-v${GBP_NODE_VERSION}-linux-x64
    add2path -q $NODEJS_HOME/bin
fi

# Configure Luarocks (Lua package installer)
if command -v luarocks &> /dev/null; then
    eval `luarocks path`
fi

# Configure Fuzzy Finder (fzf)
if [ -n "$ZSH_VERSION" ]; then
    [ -f ${GBP_HOME}/.fzf.zsh ] && source ${GBP_HOME}/.fzf.zsh
else
    [ -f ${GBP_HOME}/.fzf.bash ] && source ${GBP_HOME}/.fzf.bash
fi

# Source the Rust environment (if there is one)
if [ -e "$GBP_HOME/.cargo/env" ]; then
   . "$GBP_HOME/.cargo/env"
fi

# Eliminate duplicates in paths
if [ -n "$ZSH_VERSION" ]; then
   typeset -aU cdpath fpath path
else
   typeset -a cdpath fpath path
fi

# The "-f test" above sets $? to 1 if .fzf.X is not installed.  This breaks the
# CI tests.  To deal with this, true sets $? to zero and leads to a '0' return.
# This is safe to do because 'set -e' is set above and if we get to here, then the
# return should be zero.
true
