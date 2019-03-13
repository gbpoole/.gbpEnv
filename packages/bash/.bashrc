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

# Make sure the REMOTEHOST variable is set
if [ -z $REMOTEHOST ]; then
   export REMOTEHOST=$HOST
fi

# Make sure the DISPLAY variable is set
if [ -z $DISPLAY ]  && [ -n $REMOTEHOST ]; then
   export DISPLAY=$REMOTEHOST:0.0
fi

# Make sure /usr/local/bin is in the PATH
export PATH=$PATH:/usr/local/bin

# Source the gbpDocker environment
# variable file (if present)
if [ -e ".env.gbpDocker" ]; then
    for l in ".env.gbpDocker"; do eval $(awk '{print "export "$1}' $l) ;  done
fi

# Set all system-specific stuff
source ${GBP_HOME}/.bashrc.system

# Create some aliases
source ${GBP_HOME}/.alias.bash

# Set default editor
export EDITOR=`which vim`
if [ ! -f "${EDITOR}" ]; then
    export EDITOR=`which vi`
fi

# Add scripts to the executable to the PATH
export PATH=${GBP_HOME}/bin/scripts/:$PATH

# Add 3rd_Party binary directory to the PATH
export PATH=${GBP_HOME}/3rd_Party/bin:$PATH

# Add my_code binary directory to the PATH
export PATH=${GBP_HOME}/my_code/bin:$PATH

# Set autoloaded functions
my_autoload_path=${GBP_HOME}/bin/autoload
fpath=($my_autoload_path $fpath)
if [[ -d "$my_autoload_path" ]]; then
    for func in $my_autoload_path/*; do
        if [ -n "$ZSH_VERSION" ]; then
            autoload -Uz ${func:t}
        # autoload is not available under bash.  Do this instead.
        else
            func_filename=`basename $func`
            alias $func_filename=". $func"
        fi
    done
fi
unset my_autoload_path

# Added by travis gem
if [ -f ${GBP_HOME}/.travis/travis.sh ]; then
    source ${GBP_HOME}/.travis/travis.sh
fi

# Set the prompt (if setprompt is defined; generally not if we're not in zsh)
if [ -n "$ZSH_VERSION" ]; then
    if [ ! `alias | grep "setprompt" | wc -l` = 0 ]; then
        setprompt
    fi
else
    if [ `type -t setprompt` ]; then
        setprompt
    fi
fi
