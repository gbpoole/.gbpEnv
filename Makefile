#########################################
# Use this makefile to install software #
# that may be missing on your system.   #
#########################################

# Set the default target to 'help', which displays a list of supported targets
.PHONY: default static_dirs devenv_libs
default: all

# This ensures that we use standard (what is used in interactive shells) version of echo.
ECHO = /bin/echo

# Root into which we will install everything
INSTALL_DIR=${PWD}/../

all: static_dirs stow packages

# These directories need to be installed directly
static_dirs:
	@$(ECHO) cp -r static_dirs/* ${INSTALL_DIR}

#####################################################
## Create list of packages to be installed by Stow ##
#####################################################
PACKAGE_LIST=$(notdir $(wildcard packages/*))
.PHONY: $(PACKAGE_LIST) packages

################################
## Install packages with Stow ##
################################
$(PACKAGE_LIST):
	${INSTALL_DIR}/3rd_Party/bin/stow -d ${INSTALL_DIR} $@
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
stow-download: texi2html
	@git clone https://github.com/aspiers/stow.git
stow-config:
	@cd stow;aclocal;automake --add-missing;autoconf;./configure --prefix=${INSTALL_DIR}/3rd_Party/ --with-pmdir=${INSTALL_DIR}/3rd_Party/perl
stow-build:
	@cd stow;make -j ${N_CORES}
stow-install:
	@cd stow;make install
stow-clean:
	@rm -rf stow
	@rm -rf ${INSTALL_DIR}/3rd_Party/bin/texi2html

########################################################################################################
# texi2html                                                                                            #
# -----------------------------------------------------------------------------------------------------#
# This creates a wrapper from texi2html -> texi2any, which is in texinfo.  This is needed to build the #
# docs for `stow` which, breaks the install if it fails.   There's no option to build `stow` without   #
# docs! :( This was obtained here:                                                                     #
#     https://svn.savannah.gnu.org/viewvc/texinfo/trunk/util/texi2html?view=markup                     #
########################################################################################################
texi2html: texinfo
	@$(ECHO) '#! /bin/sh' > ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# Copyright 2012 Free Software Foundation, Inc.' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '#' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# This file is free software; as a special exception the author gives' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# unlimited permission to copy and/or distribute it, with or without' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# modifications, as long as this notice is preserved.' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '#' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# This program is distributed in the hope that it will be useful, but' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '#' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# Original author: Patrice Dumas.' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '#' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# Convert Texinfo to HTML, setting the default style to be the texi2html' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# style.' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '#' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# It is not fully compatible with texi2html.  There is no possibility of' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# splitting indices, and translated strings cannot (yet?) be customized.' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# Command line processing and options have also changed, and the' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# customization API is new.' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '#' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# Thus, since this is not a drop-in replacement for the old texi2html,' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) "# we do not install it.  It's here as an example." >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '#' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# See the texi2html node in the Texinfo manual for more.' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '#' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# The following line does not  work, but commenting it out and adding the 'touch' command that follows lets the stow build below pass." ' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) '# exec texi2any --set-init-variable TEXI2HTML=1 "$@"' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@$(ECHO) 'touch doc/manual-single.html' >> ${INSTALL_DIR}/3rd_Party/bin/texi2html
	@chmod a+x ${INSTALL_DIR}/3rd_Party/bin/texi2html

#########################
## texinfo from HEAD ##
#########################
VERSION-texinfo=6.6
texinfo-download:
	@wget https://ftp.gnu.org/gnu/texinfo/texinfo-${VERSION-texinfo}.tar.gz
	@tar xzf texinfo-${VERSION-texinfo}.tar.gz
texinfo-config:
	@cd texinfo-${VERSION-texinfo};autoreconf -iv;./configure --prefix=${INSTALL_DIR}/3rd_Party/
texinfo-build:
	@cd texinfo-${VERSION-texinfo};make -j ${N_CORES}
texinfo-install:
	@cd texinfo-${VERSION-texinfo};make install
texinfo-clean:
	@rm -rf texinfo-${VERSION-texinfo}

##############
# Print help #
##############
help:
	@$(ECHO) 
	@$(ECHO) "The following targets are available:"
	@$(ECHO) "    all - Initialize install."
	@$(ECHO) 
