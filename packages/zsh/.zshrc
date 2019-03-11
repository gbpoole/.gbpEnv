#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# If we're running tests, then exit with failure upon any error
if [ -n "$GBPENV_TEST" ] ; then 
    set -e
fi

export TERM="xterm-256color"

# Set this variable to '1' to perform profiling of zsh startup
export ZSH_PROFILE_MODE=0
if [ $ZSH_PROFILE_MODE -eq 1 ]; then
    zmodload zsh/zprof
fi
export ZSHCONFIG=${PWD}/.zsh-config

## Add 3rd_Party/bin tpo path because it may be needed by antibody packages
export PATH=$PWD/3rd_Party/bin:$PATH

# Run initialisation script
ZSH_INIT=${ZSHCONFIG}/_init.sh
if [[ -s ${ZSH_INIT} ]]; then
    source ${ZSH_INIT}
else
    echo "Could not find the zsh init script ${ZSH_INIT}"
fi

# Source the bash config
#
# If we are starting-up an iterm session, then the config
# will be in the home directory.  If we are not, then we
# may be starting from an out-of-home position.
if [ -z "$ITERM_PROFILE" ]; then
    if [[ -s $PWD/.bashrc ]]; then
        source $PWD/.bashrc
    else
        source ~/.bashrc
    fi
else
    source ~/.bashrc
fi

# https://gist.github.com/ctechols/ca1035271ad134841284
# https://carlosbecker.com/posts/speeding-up-zsh
autoload -Uz compinit
#if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ${$GBP_HOME}/.zcompdump) ]; then
    compinit
#else
#    compinit -C
#fi

# Report profiling (if activated)
if [ $ZSH_PROFILE_MODE -eq 1 ]; then
    zprof
fi
