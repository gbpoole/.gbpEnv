#########################################
# Use this makefile to install software #
# that may be missing on your system.   #
#########################################

# Set the default target to 'help', which displays a list of supported targets
.PHONY: default static_dirs devenv_libs
default: all

# Makefile path & directory
MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR = $(dir $(MAKEFILE_PATH))

# Location of the repository
REPO_DIR = ${MAKEFILE_DIR}

# Root into which we will install everything
INSTALL_DIR = ${REPO_DIR}/../

# This ensures that we use standard (what is used in interactive shells) version of echo.
ECHO = /bin/echo

# The eventual location for the Stow executable
STOW = ${INSTALL_DIR}/3rd_Party/bin/stow

export PATH := ${REPO_DIR}/stow:$(PATH)

all: submodules-init static_dirs stow packages-install

######################################################
## These directories are installed directly because ##
## we don't want their eventual contents to ever be ##
## part of this repository.                         ##
######################################################
static_dirs:
	@cp -r ${REPO_DIR}/static_dirs/* ${INSTALL_DIR}

#####################################################
## Create list of packages to be installed by Stow ##
#####################################################
PACKAGE_LIST=$(notdir $(wildcard ${REPO_DIR}/packages/*))

##################################
## Initialize/update submodules ##
##################################
submodules-init:
	@cd ${REPO_DIR};git submodule update --init --recursive
submodules-update:
	@cd ${REPO_DIR};git submodule update --recursive

#################################
### Install packages with Stow ##
#################################
.PHONY: $(addsuffix .install,$(PACKAGE_LIST)) packages-install
$(addsuffix .install,$(PACKAGE_LIST)):
	@$(ECHO) -n Installing $(basename $@)...
	@${INSTALL_DIR}/3rd_Party/bin/stow -t ${INSTALL_DIR} -d ${REPO_DIR}/packages $(basename $@)
	@$(ECHO) Done.
packages-install: $(addsuffix .install,$(PACKAGE_LIST))

##################################
### Unnstall packages with Stow ##
##################################
.PHONY: $(addsuffix .uninstall,$(PACKAGE_LIST)) packages-uninstall
$(addsuffix .uninstall,$(PACKAGE_LIST)):
	@$(ECHO) -n Uninstalling $(basename $@)...
	@${INSTALL_DIR}/3rd_Party/bin/stow -t ${INSTALL_DIR} -d ${REPO_DIR}/packages -D $(basename $@)
	@$(ECHO) Done.
packages-uninstall: $(addsuffix .uninstall,$(PACKAGE_LIST))

###################################
### Reinstall packages with Stow ##
###################################
.PHONY: $(addsuffix .reinstall,$(PACKAGE_LIST)) packages-reinstall
$(addsuffix .reinstall,$(PACKAGE_LIST)):
	@$(ECHO) -n Reinstalling $(basename $@)...
	@${INSTALL_DIR}/3rd_Party/bin/stow -t ${INSTALL_DIR} -d ${REPO_DIR}/packages -R $(basename $@)
	@$(ECHO) Done.
packages-reinstall: $(addsuffix .reinstall,$(PACKAGE_LIST))

#######################
## Generic libraries ##
#######################
generic_libs = stow texinfo
.PHONY: $(generic_libs)
$(generic_libs): % : %-download %-config %-build %.install %-clean

###################
## Install stow  ##
###################
stow-download: 
	@cd ${REPO_DIR};git clone https://github.com/aspiers/stow.git
stow-config:
	@cd ${REPO_DIR}/stow;aclocal;automake --add-missing;autoconf;./configure --prefix=${INSTALL_DIR}/3rd_Party/ --with-pmdir=${INSTALL_DIR}/3rd_Party/perl
stow-build: texi2html
	@cd ${REPO_DIR}/stow;make -j 4
stow.install:
	@cd ${REPO_DIR}/stow;make install
stow-clean:
	@rm -rf ${REPO_DIR}/stow

########################################################################################################
# texi2html                                                                                            #
# -----------------------------------------------------------------------------------------------------#
# This creates a wrapper from texi2html -> texi2any, which is in texinfo.  This is needed to build the #
# docs for `stow` which, breaks the install if it fails.   There's no option to build `stow` without   #
# docs! :( This was obtained here:                                                                     #
#     https://svn.savannah.gnu.org/viewvc/texinfo/trunk/util/texi2html?view=markup                     #
########################################################################################################
texi2html: 
	@$(ECHO) "#! /bin/sh" > ${REPO_DIR}/stow/texi2html
	@$(ECHO) "# The 'touch' command that follows lets the stow build below pass." >> ${REPO_DIR}/stow/texi2html
	@$(ECHO) "touch doc/manual-single.html" >> ${REPO_DIR}/stow/texi2html
	@chmod a+x ${REPO_DIR}/stow/texi2html

##############
# Print help #
##############
help:
	@$(ECHO) 
	@$(ECHO) "The following targets are available:"
	@$(ECHO) "    all [default]      - Initialize"
	@$(ECHO) "    stow               - Build and install Gnu Stow"
	@$(ECHO) "    packages-install   - Install everython in 'packages' with Stow"
	@$(ECHO) "    packages-uninstall - Uninstall everython in 'packages' with Stow"
	@$(ECHO) "    packages-reinstall - Reinstall everython in 'packages' with Stow"
	@$(ECHO) 
