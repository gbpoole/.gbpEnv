#!/bin/bash

# Set-up some generic UNIX stuff
umask 22
ulimit -c 0
unset autologout

# It is possible to install this repo somewhere
# other than the home directory.  Set the path
# to the repo directory here.
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
    echo "test:"${EDITOR}
    export EDITOR=`which vi`
fi

# Add 3rd_Party binary directory to the PATH
export PATH=${GBP_HOME}/3rd_Party/bin:$PATH

# Configure taskwarrior
if [ "${GBP_HOME}" != "${HOME}" ]; then
    export TASKRC=${GBP_HOME}/.taskrc
    export TASKDATA=${GBP_HOME}/.task
fi

# These lines set-up gbpCode
export GBP_SRC=${GBP_HOME}'/gbpCode/'
if [ -f ${GBP_SRC}/.bashrc.myCode ]; then
  source ${GBP_SRC}/.bashrc.myCode
elif [ -f ${GBP_SRC}/.bashrc.gbpCode ]; then
  source ${GBP_SRC}/.bashrc.gbpCode
fi
export PATH=${GBP_HOME}/my_code/bin:$PATH

# added by travis gem
if [ -f ${GBP_HOME}/.travis/travis.sh ]; then
    source ${GBP_HOME}/.travis/travis.sh
fi

# Set the prompt
if [ "${ZSH_THEME}" = "" ]; then
    setprompt
fi
