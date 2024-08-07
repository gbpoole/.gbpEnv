#########################################################################
# Use this makefile to install gbpEnv.  See README.md for instructions. #
#########################################################################

# Set the default target to 'help', which displays a list of supported targets
.PHONY: default static_dirs devenv_libs
default: init

# Makefile path & directory
MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR = $(dir $(MAKEFILE_PATH))

# Location of the repository
REPO_DIR = ${MAKEFILE_DIR}

# Root into which we will install everything (parent dir of REPO_DIR)
INSTALL_DIR = $(abspath ${REPO_DIR}/../)

# This ensures that we use standard (what is used in interactive shells) version of echo.
ECHO = /bin/echo

# Makes sure Homebrew is in the path (obviously: not set yet if this is a fresh install!)
export PATH := $(PATH):/opt/homebrew/bin

# Set-up Stow executable
export PATH := ${INSTALL_DIR}/3rd_Party/bin:$(PATH)
STOW = $(shell which stow)
check_stow:
ifeq (${STOW},)
	$(error No installation of 'Stow' detected.  Either install it with brew, apt-get, etc. or make it first by calling 'make stow')
endif

# Init (default) builds the following targets
init: check_stow submodules-init static_dirs packages-install 3rd_Party_required

######################################################
## These directories are installed directly because ##
## we don't want their eventual contents to ever be ##
## part of this repository.                         ##
######################################################
static_dirs:
	@cp -r ${REPO_DIR}/static_dirs/* ${INSTALL_DIR}

###################################################
## Create list of packages to be managed by Stow ##
###################################################
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
	@${STOW} -t ${INSTALL_DIR} -d ${REPO_DIR}/packages $(basename $@)
	@$(ECHO) Done.
packages-install: check_stow $(addsuffix .install,$(PACKAGE_LIST))

##################################
### Unnstall packages with Stow ##
##################################
.PHONY: $(addsuffix .uninstall,$(PACKAGE_LIST)) packages-uninstall
$(addsuffix .uninstall,$(PACKAGE_LIST)):
	@$(ECHO) -n Uninstalling $(basename $@)...
	@${STOW} -t ${INSTALL_DIR} -d ${REPO_DIR}/packages -D $(basename $@)
	@$(ECHO) Done.
packages-uninstall: check_stow $(addsuffix .uninstall,$(PACKAGE_LIST))

###################################
### Reinstall packages with Stow ##
###################################
.PHONY: $(addsuffix .reinstall,$(PACKAGE_LIST)) packages-reinstall
$(addsuffix .reinstall,$(PACKAGE_LIST)):
	@$(ECHO) -n Reinstalling $(basename $@)...
	@${STOW} -t ${INSTALL_DIR} -d ${REPO_DIR}/packages -R $(basename $@)
	@$(ECHO) Done.
packages-reinstall: check_stow $(addsuffix .reinstall,$(PACKAGE_LIST))

##########
# Update #
##########
.PHONY: pull_from_master update
# We may have wiped (or may not have initialized) git.  Temporarily install and then uninstall.
pull_from_master: git.install _do_pull_from_master git.uninstall
_do_pull_from_master: git.install
	@cd ${REPO_DIR};git pull origin master
update: packages-uninstall pull_from_master packages-install

#######################
## Generic libraries ##
#######################
generic_libs = stow
.PHONY: $(generic_libs)
$(generic_libs): % : %-download %-config %-build %.install %-clean

###################
## Install stow  ##
###################
stow-download:
	@cd ${REPO_DIR};rm -rf stow
	@cd ${REPO_DIR};git clone https://git.savannah.gnu.org/git/stow.git
stow-config:
	@cd ${REPO_DIR}/stow;aclocal;automake --add-missing;autoconf;./configure --prefix=${INSTALL_DIR}/3rd_Party/ --with-pmdir=${INSTALL_DIR}/3rd_Party/perl
stow-build: texi2html
	@cd ${REPO_DIR}/stow;make -j 4
stow.install:
	@cd ${REPO_DIR}/stow;make install
stow-clean:
	@rm -rf ${REPO_DIR}/stow

#############################
## Required 3rd Party Code ##
#############################
3rd_Party_required = fzy
.PHONY: $(3rd_Party_required) 3rd_Party_required
$(3rd_Party_required):
	cd ${INSTALL_DIR}/3rd_Party/; make $@
3rd_Party_required: $(3rd_Party_required)

########################################################################################################
# texi2html                                                                                            #
# -----------------------------------------------------------------------------------------------------#
# This creates a wrapper from texi2html -> texi2any, which is in texinfo.  This is needed to build the #
# docs for `stow` which, breaks the install if it fails.   There's no option to build `stow` without   #
# docs! :( This was obtained here:                                                                     #
#     https://svn.savannah.gnu.org/viewvc/texinfo/trunk/util/texi2html?view=markup                     #
#        ****** Should be depricated, now that Stow has addressed this problem in v2.3.0 ******        #
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
	@$(ECHO) "The following targets are available (install directory assumed to be the run directory):"
	@$(ECHO) "    init [default]     - Initialize"
	@$(ECHO) "    stow               - Build and install Gnu Stow"
	@$(ECHO) "    3rd_Party_required - Build all the 3rd Party codes required by this install"
	@$(ECHO) "    packages-install   - Install everython in 'packages' with Stow"
	@$(ECHO) "    packages-uninstall - Uninstall everything in 'packages' with Stow"
	@$(ECHO) "    packages-reinstall - Reinstall everything in 'packages' with Stow"
	@$(ECHO) 
