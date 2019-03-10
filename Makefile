#########################################
# Use this makefile to install software #
# that may be missing on your system.   #
#########################################

# Set the default target to 'help', which displays a list of supported targets
.PHONY: default static_dirs devenv_libs
default: all

# This ensures that we use standard (what is used in interactive shells) version of echo.
ECHO = /bin/echo

STOW = ${INSTALL_DIR}/3rd_Party/bin/stow

# Root into which we will install everything
REPO_DIR=${PWD}
INSTALL_DIR=${REPO_DIR}/../

export PATH := ${REPO_DIR}/stow:$(PATH)

all: static_dirs stow packages

# These directories need to be installed directly
static_dirs:
	@cp -r static_dirs/* ${INSTALL_DIR}

#####################################################
## Create list of packages to be installed by Stow ##
#####################################################
PACKAGE_LIST=$(notdir $(wildcard packages/*))
.PHONY: $(PACKAGE_LIST) packages

################################
## Install packages with Stow ##
################################
$(PACKAGE_LIST):
	${INSTALL_DIR}/3rd_Party/bin/stow -t ${INSTALL_DIR} -d packages $@
packages: $(PACKAGE_LIST)

#######################
## Generic libraries ##
#######################
generic_libs = stow texinfo
.PHONY: $(generic_libs)
$(generic_libs): % : %-download %-config %-build %-install %-clean

###################
## Install stow  ##
###################
stow-download: 
	@git clone https://github.com/aspiers/stow.git
stow-config:
	@cd stow;aclocal;automake --add-missing;autoconf;./configure --prefix=${INSTALL_DIR}/3rd_Party/ --with-pmdir=${INSTALL_DIR}/3rd_Party/perl
stow-build: texi2html
	@cd stow;make -j 4
stow-install:
	@cd stow;make install
stow-clean:
	@rm -rf stow

########################################################################################################
# texi2html                                                                                            #
# -----------------------------------------------------------------------------------------------------#
# This creates a wrapper from texi2html -> texi2any, which is in texinfo.  This is needed to build the #
# docs for `stow` which, breaks the install if it fails.   There's no option to build `stow` without   #
# docs! :( This was obtained here:                                                                     #
#     https://svn.savannah.gnu.org/viewvc/texinfo/trunk/util/texi2html?view=markup                     #
########################################################################################################
texi2html: 
	@$(ECHO) '#! /bin/sh' > stow/texi2html
	@$(ECHO) '# The 'touch' command that follows lets the stow build below pass." ' >> stow/texi2html
	@$(ECHO) 'touch doc/manual-single.html' >> stow/texi2html
	@chmod a+x stow/texi2html

##############
# Print help #
##############
help:
	@$(ECHO) 
	@$(ECHO) "The following targets are available:"
	@$(ECHO) "    all - Initialize install."
	@$(ECHO) 
