#########################################
# Use this makefile to install software #
# that may be missing on your system.   #
#########################################

# Set the default target to 'help', which displays a list of supported targets
.PHONY: default
default: help

# This ensures that we use standard (what is used in interactive shells) version of echo.
ECHO = /bin/echo
export ECHO

##################
## set versions ##
##################
VERSION-gcc=7.3.0
VERSION-mpich=3.2
VERSION-gsl=2.4
VERSION-gd=2.2.5
VERSION-cfitsio=3450
VERSION-fftw2=
VERSION-fftw3=

###############################################
## List of supported generic library targets ##
###############################################
generic_libs = gcc mpich cfitsio gsl gd fftw2 fftw3

############################
## Generic library target ##
############################
.PHONY: $(generic_libs)
$(generic_libs): % : %-download %-config %-build %-install %-clean

#########
## GCC ##
#########
gcc-download:
	@wget https://ftp.gnu.org/gnu/gcc/gcc-${VERSION-gcc}/gcc-${VERSION-gcc}.tar.gz
	@tar xzf gcc-${VERSION-gcc}.tar.gz
	@cd gcc-${VERSION-gcc} ; ./contrib/download_prerequisites
gcc-config:
	@mkdir build-gcc
	@cd build-gcc;../gcc-${VERSION-gcc}/configure --prefix=${GBP_HOME}/3rd_Party/ --enable-languages=c,c++ --disable-multilib
gcc-build:
	@cd build-gcc;make -j 8
gcc-install:
	@cd build-gcc;make install
gcc-clean:
	@rm -rf build-gcc gcc-${VERSION-gcc}*

###########
## mpich ##
###########
mpich-download:
	@wget http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz
	@tar xzf mpich-${VERSION-mpich}.tar.gz
mpich-config:
	@mkdir build-mpich
	@cd build-mpich ; ./configure          \
        	--prefix=${GBP_HOME}/3rd_Party \
        	--enable-static=false          \
        	--enable-alloca=true           \
        	--disable-long-double          \
        	--enable-threads=single        \
        	--enable-fortran=no            \
        	--enable-fast=all              \
        	--enable-g=none                \
        	--enable-timing=none
mpich-build:
	@cd build-mpich;make -j 8
mpich-install:
	@cd build-mpich;make install
mpich-clean:
	@rm -rf build-mpich mpich-${VERSION-mpich}*

#############
## CFITSIO ##
#############
# Note: out-of-source builds seem to be broken (with version 3450 at least)
# so everything is done directly in the cfitsio directory here.
cfitsio-download:
	@wget http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio${VERSION-cfitsio}.tar.gz
	@tar xzf cfitsio${VERSION-cfitsio}.tar.gz
cfitsio-config:
	@cd cfitsio;../cfitsio/configure --prefix=${GBP_HOME}/3rd_Party/
cfitsio-build:
	@cd cfitsio;make -j 4
cfitsio-install:
	@cd cfitsio;make install
cfitsio-clean:
	@rm -rf cfitsio cfitsio${VERSION-cfitsio}*

#########
## GSL ##
#########
gsl-download:
	@wget https://ftp.gnu.org/gnu/gsl/gsl-${VERSION-gsl}.tar.gz
	@tar xzf gsl-${VERSION-gsl}.tar.gz
gsl-config:
	@mkdir build-gsl
	@cd build-gsl;../gsl-${VERSION-gsl}/configure --prefix=${GBP_HOME}/3rd_Party/
gsl-build:
	@cd build-gsl;make -j 4
gsl-install:
	@cd build-gsl;make install
gsl-clean:
	@rm -rf build-gsl gsl-${VERSION-gsl}*

########
## GD ##
########
gd-download:
	@wget https://github.com/libgd/libgd/releases/download/gd-${VERSION-gd}/libgd-${VERSION-gd}.tar.gz
	@tar xzf libgd-${VERSION-gd}.tar.gz
gd-config:
	@mkdir build-gd
	@cd build-gd;../libgd-${VERSION-gd}/configure --prefix=${GBP_HOME}/3rd_Party/
gd-build:
	@cd build-gd;make -j 4
gd-install:
	@cd build-gd;make install
gd-clean:
	@rm -rf build-gd gd-${VERSION-gd}

###########
## FFTW2 ##
###########
fftw2-download:
fftw2-config:
fftw2-build:
fftw2-install:
fftw2-clean:

###########
## FFTW3 ##
###########
fftw3-download:
fftw3-config:
fftw3-build:
fftw3-install:
fftw3-clean:

##############
# Print help #
##############
help:
	@$(ECHO) 
	@$(ECHO) "The following targets are available:"
	@$(ECHO) "	gcc   - Install GCC   version "${VERSION-gcc}  " (takes ~2 hr)"
	@$(ECHO) "	mpich - Install MPICH version "${VERSION-mpich}" (takes ~2 hr)"
	@$(ECHO) "      gsl   - Install GSL   version "${VERSION-gsl}  " (takes ~X hr)"
	@$(ECHO) "      fftw2 - Install FFTW  version "${VERSION-fftw2}" (takes ~X hr)"
	@$(ECHO) "      fftw3 - Install FFTW  version "${VERSION-fftw3}" (takes ~X hr)"
	@$(ECHO) 
