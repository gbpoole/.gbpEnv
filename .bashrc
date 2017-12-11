# It is possible to install this repo somewhere
# other than the home directory.  Set the path
# to the repo directory here.
echo test1 ${PWD}
if [ -f ${PWD}/.bashrc ]; then
   export GBP_HOME=${PWD}
else
   export GBP_HOME=${HOME}
fi
echo test2 ${GBP_HOME}

source ${GBP_HOME}/.bashrc.gbpHome

# added by travis gem
if [ -f ${GBP_HOME}/.travis/travis.sh ]; then
    source ${GBP_HOME}/.travis/travis.sh
fi

