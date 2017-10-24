# It is possible to install this repo somewhere
# other than the home directory.  Set the path
# to the repo directory here.
export GBP_HOME=${PWD}

source ${GBP_HOME}/.bashrc.gbpHome

# added by travis gem
if [ -f ${GBP_HOME}/.travis/travis.sh ]; then
    source ${GBP_HOME}/.travis/travis.sh
fi

