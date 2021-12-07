#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# Set this variable to '1' to perform profiling of zsh startup
export ZSH_PROFILE_MODE=0
if [ $ZSH_PROFILE_MODE -eq 1 ]; then
    zmodload zsh/zprof
fi

# If we're running tests, then exit with failure upon any error
if [ -n "$GBPENV_TEST" ] ; then 
    set -e
fi

export TERM="xterm-256color"

# It is possible to configure this environment somewhere
# other than the home directory.  This is useful when you
# want the configuration here to be applied in a shared-account
# situation.  Set the path to the install here.
if [ ! -f "${GBP_HOME}/.zshrc" ]; then
    if [ -f ${PWD}/.zshrc ]; then
       export GBP_HOME=${PWD}
    else
       export GBP_HOME=${HOME}
    fi
fi

# Add 3rd_Party/bin to path because it may be needed by antibody packages
export PATH=${GBP_HOME}/3rd_Party/bin:$PATH

# Run initialisation script
export ZSHCONFIG=${GBP_HOME}/.zsh-config
export ZSH_INIT=${ZSHCONFIG}/_init.sh
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
        source ${GBP_HOME}/.bashrc
    fi
else
    source ${GBP_HOME}/.bashrc
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

[ -f ${GBP_HOME}/.fzf.zsh ] && source ${GBP_HOME}/.fzf.zsh

export PATH="$HOME/.poetry/bin:$PATH"
