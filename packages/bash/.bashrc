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

# LIGO Data Grid configuration
pcdev1=gregory.poole@ldas-pcdev1.ligo.caltech.edu
GLOBUS_LOCATION=/opt/ldg
export GLOBUS_LOCATION
if [ -f ${GLOBUS_LOCATION}/etc/globus-user-env.sh ] ; then
	. ${GLOBUS_LOCATION}/etc/globus-user-env.sh
fi
go_LDG.proxy () { ligo-proxy-init albert.einstein; }
go_LDG () { gsissh -YC $pcdev1 ; }

# Add '3rd_Party' and 'my_code' directories to paths
add2path -q ${GBP_HOME}/my_code/bin
add2path -q ${GBP_HOME}/3rd_Party/bin
export LD_LIBRARY_PATH="${GBP_HOME}/my_code/lib:${GBP_HOME}/3rd_Party/lib:${LD_LIBRARY_PATH}"
export INCLUDE="${GBP_HOME}/my_code/include:${GBP_HOME}/3rd_Party/include:${INCLUDE}"
export CPATH="${GBP_HOME}/my_code/include:${GBP_HOME}/3rd_Party/include:${CPATH}"
export PKG_CONFIG_PATH=${GBP_HOME}/3rd_Party/lib/pkgconfig:${PKG_CONFIG_PATH}

# If using a custom-installed gcc, then 3rd party libraries will end-up in the following 
# path ... prepend it to make sure it is preferred over a system install
export LD_LIBRARY_PATH="${GBP_HOME}/3rd_Party/lib64:${LD_LIBRARY_PATH}"

# Add ~/bin to PATH
add2path -q ${GBP_HOME}/bin

# Set-up Anaconda
GBP_USE_CONDA=false
if [ ${GBP_USE_CONDA} -a -f ${GBP_CONDA_PATH}/etc/profile.d/conda.sh ]; then
    source ${GBP_CONDA_PATH}/etc/profile.d/conda.sh

    # Set-up some scripts so that Tox can find all the versions of 
    # python we have installed under Anaconda.  This assumes that there is
    # a conda environment named pythonX.Y for every X.Y version of python
    # we may want to run tox against.
    #
    # To create a new conda environment for python version X.Y, run this:
    #    conda create --name pythonX.Y python=X.Y
    #
    # Also, you might have to install the Anaconda version of virtualenv like this:
    #    conda install virtualenv
    #
    # See here for more info and for directions for how to do this under windows:
    #    https://deparkes.co.uk/2018/06/04/use-tox-with-anaconda/
    if [ -n "$ZSH_VERSION" ]; then
        unsetopt nomatch
    fi
    GBP_CONDA_SCRIPTS_PATH=$GBP_HOME/bin/anaconda
    if [ ! -d $GBP_CONDA_SCRIPTS_PATH ];then
        mkdir $GBP_CONDA_SCRIPTS_PATH
    fi
    if [ -d $GBP_CONDA_PATH/envs ]; then
        export GBP_CONDA_ENVS_PATH=$GBP_CONDA_PATH/envs
        GBP_CONDA_ENVS_PATH_LIST=`find $GBP_CONDA_ENVS_PATH/python?.?/bin -name "python?.?" 2> /dev/null`
        fi
      if [ -z "$GBP_CONDA_ENVS_PATH_LIST" ]; then
          export GBP_CONDA_ENVS_PATH=${GBP_HOME}/.conda/envs
          GBP_CONDA_ENVS_PATH_LIST=`find $GBP_CONDA_ENVS_PATH/python?.?/bin -name "python?.?" 2> /dev/null`
      fi
      if [ -z "$GBP_CONDA_ENVS_PATH_LIST" ]; then
          unset GBP_CONDA_ENVS_PATH
      else
          # For some reason, I need to redo the find because it doesn't iterate over items if I use $GBP_CONDA_ENVS_PATH_LIST
          for path_i in `find $GBP_CONDA_ENVS_PATH/python?.?/bin -name "python?.?"`; do
              version_i=`basename $path_i`
              exec_i=$GBP_CONDA_SCRIPTS_PATH/$version_i
              if [ ! -x $exec_i ]; then
                  echo "#!/bin/bash" > $exec_i
                  echo $path_i '"$@"' >> $exec_i
                  chmod uo+x $exec_i
              fi
          done
      fi
      add2path -q $GBP_CONDA_SCRIPTS_PATH
      if [ -n "$ZSH_VERSION" ]; then
          setopt nomatch
      fi
  fi

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

# Set 'default' Anaconda environment
# This needs to be after the autoload functions are loaded
  if [ ${GBP_USE_CONDA} -a type conda.load > /dev/null 2>&1 ]; then
    conda.load default
  fi

# Init pyenv
export PYENV_ROOT="${GBP_HOME}/.pyenv"
add2path -q -f ${PYENV_ROOT}/bin
add2path -q -f ${PYENV_ROOT}/shims
if type pyenv > /dev/null 2>&1; then
   export GBP_PYENV_DEFAULT_VERSION=3.10.5
   export GBP_PYENV_DEFAULT_ENV=default
   export PYENV_HOOK_PATH=${GBP_HOME}/.config/pyenv/pyenv.d/
   export PYENV_VIRTUALENV_DISABLE_PROMPT=1
   eval "$(pyenv init -)"
   eval "$(pyenv virtualenv-init -)"
   # Note that the following check is broken if the ${GBP_PYENV_DEFAULT_ENV} environment is missing
   # but 'pyenv global' is set to ${GBP_PYENV_DEFAULT_ENV}.  The 'pyenv activate' call returns
   # '0' in that case, for some reason.
   pyenv activate ${GBP_PYENV_DEFAULT_ENV} 2>/dev/null
   rval=$?
   if [[ $rval -ne 0 ]]; then
      echo "Default Python environment ("${GBP_PYENV_DEFAULT_ENV}") not found ... initializing ..."
      pyenv install ${GBP_PYENV_DEFAULT_VERSION}
      pyenv virtualenv ${GBP_PYENV_DEFAULT_VERSION} ${GBP_PYENV_DEFAULT_ENV}
      pyenv global default
   fi
fi
unset PYENV_VERSION
unset rval

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$GBP_HOME/.pip/cache

# Add path for Poetry
add2path -q -f ${GBP_HOME}/.local/bin/

## Configure Python - End ##

# Create aliases
source ${GBP_HOME}/.alias.bash

# Rust set-up
if [ -f "${GBP_HOME}/.cargo/env" ]; then
   . $GBP_HOME/.cargo/env
fi

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

# Set the verion of Node.js that we will use and add it to the path
# n.b.: If you change this, then node needs to be updated - not just here - but
#       on any other extant install of .gbpEnv that will pull this change.
# TODO: Find a better way to manage this
export GBP_NODE_VERSION=14.17.0
if [ $GBP_OS = 'Mac' ]; then
    export GBP_NODE_PLATFORM=darwin-x64
else
    export GBP_NODE_PLATFORM=linux-x64
fi
export NODEJS_HOME=${GBP_HOME}/3rd_Party/node-v${GBP_NODE_VERSION}-${GBP_NODE_PLATFORM}
add2path -q $NODEJS_HOME/bin

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
