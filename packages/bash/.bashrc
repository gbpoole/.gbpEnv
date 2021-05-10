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
echo test1
if [ ! -f "${GBP_HOME}/.bashrc.system" ]; then
    if [ -f ${PWD}/.bashrc ]; then
       export GBP_HOME=${PWD}
    else
       export GBP_HOME=${HOME}
    fi
fi

# Set autoloaded functions
echo test2
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
echo test2

# Make sure the REMOTEHOST variable is set
if [ -z $REMOTEHOST ]; then
   export REMOTEHOST=$HOST
fi
echo test3

# Make sure the DISPLAY variable is set
if [ -z $DISPLAY ]  && [ -n $REMOTEHOST ]; then
   export DISPLAY=$REMOTEHOST:0.0
fi
echo test4

# Make sure /usr/local/bin is in the PATH
add2path -q /usr/local/bin
echo test5

# Source the gbpDocker environment
# variable file (if present)
if [ -e ".env.gbpDocker" ]; then
    for l in ".env.gbpDocker"; do eval $(awk '{print "export "$1}' $l) ;  done
fi
echo test6

# Set all system-specific stuff
source ${GBP_HOME}/.bashrc.system

# Run all remote interactive shells in tmux
echo test7
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
echo test8
export EDITOR=`which vim`
if [ ! -f "${EDITOR}" ]; then
    export EDITOR=`which vi`
fi

# Add scripts to the executable to the PATH
echo test9
add2path -q -f ${GBP_HOME}/bin/scripts

# Add 3rd_Party binary directory to the PATH
add2path -q -f ${GBP_HOME}/3rd_Party/bin

# Add my_code binary directory to the PATH
add2path -q -f ${GBP_HOME}/my_code/bin
echo test10

# Configure Perl
export PERL_LOCAL_LIB_ROOT=${GBP_HOME}/.perl5
export PATH=${PERL_LOCAL_LIB_ROOT}/bin:$PATH
export PERL5LIB=${PERL_LOCAL_LIB_ROOT}/lib/perl5:$PERL5LIB
export PERL_MB_OPT="--install_base \"${PERL_LOCAL_LIB_ROOT}\""
export PERL_MM_OPT="INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}"
echo test11

## Set 'default' Anaconda environment
## This needs to be after the autoload functions are loaded
#if type conda.load > /dev/null 2>&1; then
#   conda.load default
#fi

# Create aliases
echo test12
source ${GBP_HOME}/.alias.bash

# Set the filename for the global Matplotlib config
echo test13
export MATPLOTLIBRC=${GBP_HOME}/.config/matplotlib/matplotlibrc

# Added by travis gem
echo test14
if [ -f ${GBP_HOME}/.travis/travis.sh ]; then
    source ${GBP_HOME}/.travis/travis.sh
fi

echo test15
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

echo test16
# Set the verion of Node.js that we will use
export GBP_NODE_VERSION=12.13.1
if [ -f ${GBP_HOME}/3rd_Party/node-v${GBP_NODE_VERSION}-linux-x64/bin/node ]; then
    export NODEJS_HOME=${GBP_HOME}/3rd_Party/node-v${GBP_NODE_VERSION}-linux-x64
    add2path -q $NODEJS_HOME/bin
fi
echo test17

# Configure Luarocks (Lua package installer)
if command -v luarocks &> /dev/null; then
    eval `luarocks path`
fi

echo test18
# Configure Fuzzy Finder (fzf)
if [ -n "$ZSH_VERSION" ]; then
    [ -f ${GBP_HOME}/.fzf.zsh ] && source ${GBP_HOME}/.fzf.zsh
else
    [ -f ${GBP_HOME}/.fzf.bash ] && source ${GBP_HOME}/.fzf.bash
fi
