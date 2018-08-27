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

# Number of cores to compile with
N_CORES=4

##################
## set versions ##
##################
VERSION-gcc=7.3.0
VERSION-cmake=3.11.2
VERSION-mpich=3.2
VERSION-gsl=2.4
VERSION-gd=2.2.5
VERSION-cfitsio=3450
VERSION-fftw2=2.1.5

###############################################
## List of supported generic library targets ##
###############################################
generic_libs = gcc cmake mpich gsl cfitsio gd fftw2

############################
## Generic library target ##
############################
.PHONY: $(generic_libs)
$(generic_libs): % : %-download %-config %-build %-install %-clean

#########################################
# Use this target to make all libraries #
#########################################
all: $(generic_libs)

#########
## GCC ##
#########
gcc-download:
	@wget https://ftp.gnu.org/gnu/gcc/gcc-${VERSION-gcc}/gcc-${VERSION-gcc}.tar.gz
	@$(ECHO) Uncompressing ...;tar xzf gcc-${VERSION-gcc}.tar.gz;$(ECHO) Done.
	@cd gcc-${VERSION-gcc} ; $(ECHO) Downloading prerequisites... ; ./contrib/download_prerequisites;$(ECHO) Done.
gcc-config:
	@mkdir build-gcc
	@cd build-gcc;../gcc-${VERSION-gcc}/configure --prefix=${GBP_HOME}/3rd_Party/ --enable-languages=c,c++ --disable-multilib
gcc-build:
	@cd build-gcc;make -j ${N_CORES}
gcc-install:
	@cd build-gcc;make install
gcc-clean:
	@rm -rf build-gcc gcc-${VERSION-gcc}*

###########
## CMAKE ##
###########
cmake-download:
	@wget https://cmake.org/files/v3.11/cmake-${VERSION-cmake}.tar.gz
	@$(ECHO) Uncompressing ...;tar xzf cmake-${VERSION-cmake}.tar.gz;$(ECHO) Done.
cmake-config:
	@mkdir build-cmake
	@cd build-cmake;../cmake-${VERSION-cmake}/bootstrap --prefix=${GBP_HOME}/3rd_Party
cmake-build:
	@cd build-cmake;gmake 
cmake-install:
	@cd build-cmake;gmake install
cmake-clean:
	@rm -rf build-cmake cmake-${VERSION-cmake}*

###########
## mpich ##
###########
mpich-download:
	@wget http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz
	@tar xzf mpich-${VERSION-mpich}.tar.gz
mpich-config:
	@mkdir build-mpich
	@cd build-mpich ; ../mpich-${VERSION-mpich}/configure  \
        	--prefix=${GBP_HOME}/3rd_Party                 \
        	--enable-static=false                          \
        	--enable-alloca=true                           \
        	--disable-long-double                          \
        	--enable-threads=single                        \
        	--enable-fortran=no                            \
        	--enable-fast=all                              \
        	--enable-g=none                                \
        	--enable-timing=none
mpich-build:
	@cd build-mpich;make -j ${N_CORES}
mpich-install:
	@cd build-mpich;make install
mpich-clean:
	@rm -rf build-mpich mpich-${VERSION-mpich}*

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
	@cd build-gsl;make -j ${N_CORES}
gsl-install:
	@cd build-gsl;make install
gsl-clean:
	@rm -rf build-gsl gsl-${VERSION-gsl}*

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
	@cd cfitsio;make -j ${N_CORES}
cfitsio-install:
	@cd cfitsio;make install
cfitsio-clean:
	@rm -rf cfitsio cfitsio${VERSION-cfitsio}*

########
## GD ##
########
gd-download:
	# Use '--no-check-certificate' to avoid SSL error. See (for example): 
	#    https://stackoverflow.com/questions/28757232/unable-to-establish-ssl-connection-upon-wget-on-ubuntu-14-04-lts
	@wget --no-check-certificate https://github.com/libgd/libgd/releases/download/gd-${VERSION-gd}/libgd-${VERSION-gd}.tar.gz
	@tar xzf libgd-${VERSION-gd}.tar.gz
gd-config:
	@mkdir build-gd
	@cd build-gd;../libgd-${VERSION-gd}/configure --prefix=${GBP_HOME}/3rd_Party/
gd-build:
	@cd build-gd;make -j ${N_CORES}
gd-install:
	@cd build-gd;make install
gd-clean:
	@rm -rf build-gd libgd-${VERSION-gd}*

###########
## FFTW2 ##
###########
fftw2-download:
	@wget http://www.fftw.org/fftw-${VERSION-fftw2}.tar.gz
	@tar xzf fftw-${VERSION-fftw2}.tar.gz
fftw2-config:
	@mkdir build-fftw2-sp
	@mkdir build-fftw2-dp
	@mkdir build-fftw2-sp-mpi
	@mkdir build-fftw2-dp-mpi
	@cd build-fftw2-sp;../fftw-${VERSION-fftw2}/configure --enable-type-prefix --prefix=${GBP_HOME}/3rd_Party/ --enable-float
	@cd build-fftw2-dp;../fftw-${VERSION-fftw2}/configure --enable-type-prefix --prefix=${GBP_HOME}/3rd_Party/ 
	@cd build-fftw2-sp-mpi;../fftw-${VERSION-fftw2}/configure --enable-type-prefix --prefix=${GBP_HOME}/3rd_Party/ --enable-mpi --enable-float
	@cd build-fftw2-dp-mpi;../fftw-${VERSION-fftw2}/configure --enable-type-prefix --prefix=${GBP_HOME}/3rd_Party/ --enable-mpi
fftw2-build:
	@cd build-fftw2-sp;make -j ${N_CORES}
	@cd build-fftw2-dp;make -j ${N_CORES}
	@cd build-fftw2-sp-mpi;make -j ${N_CORES}
	@cd build-fftw2-dp-mpi;make -j ${N_CORES}
fftw2-install:
	@cd build-fftw2-sp;make install
	@cd build-fftw2-dp;make install
	@cd build-fftw2-sp-mpi;make install
	@cd build-fftw2-dp-mpi;make install
fftw2-clean:
	@rm -rf build-fftw2* fftw-${VERSION-fftw}*

##############
# Print help #
##############
help:
	@$(ECHO) 
	@$(ECHO) "The following targets are available:"
	@$(ECHO) "    all     - Make all the libraries listed below."
	@$(ECHO) "    gcc     - Install GCC     version: "${VERSION-gcc}    " (takes ~2 hr)"
	@$(ECHO) "    cmake   - Install CMAKE   version: "${VERSION-cmake}  " (takes ~X hr)"
	@$(ECHO) "    mpich   - Install MPICH   version: "${VERSION-mpich}  " (takes ~2 hr)"
	@$(ECHO) "    gsl     - Install GSL     version: "${VERSION-gsl}    " (takes ~X hr)"
	@$(ECHO) "    cfitsio - Install cfitsio version: "${VERSION-cfitsio}" (takes ~X hr)"
	@$(ECHO) "    gd      - Install libgd   version: "${VERSION-gd}     " (takes ~X hr)"
	@$(ECHO) "    fftw2   - Install FFTW    version: "${VERSION-fftw2}  " (takes ~X hr)"
	@$(ECHO) 
