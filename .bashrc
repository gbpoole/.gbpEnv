#!/bin/bash
# vim:syntax=sh
# vim:filetype=sh

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

# Create all my aliases
source ${GBP_HOME}/.bashrc.alias

# Set default editor
export EDITOR=`which vim`
if [ ! -f "${EDITOR}" ]; then
    export EDITOR=`which vi`
fi

# Add 3rd_Party binary directory to the PATH
export PATH=${GBP_HOME}/3rd_Party/bin:$PATH

# These lines set-up my_code
export PATH=${GBP_HOME}/my_code/bin:$PATH

# Added by travis gem
if [ -f ${GBP_HOME}/.travis/travis.sh ]; then
    source ${GBP_HOME}/.travis/travis.sh
fi

# Set the prompt (if we're not in zsh)
if [ "${ZSH_VERSION}" = "" ]; then
    setprompt
fi
