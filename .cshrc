#!/bin/tcsh -f

# Source .profile (if it exists)
if ( -f ${HOME}/.profile ) then
  source ${HOME}/.profile 
endif

# Source my stuff
source ~/.cshrc.gbpHome

