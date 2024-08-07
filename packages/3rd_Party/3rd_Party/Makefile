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
VERSION-lua=5.4.4
VERSION-luarocks=3.9.2
VERSION-bitop=1.0.2
VERSION-node=${GBP_NODE_VERSION}
VERSION-gcc=7.3.0
VERSION-cmake=3.24.0
VERSION-mpich=3.2
VERSION-gsl=2.4
VERSION-gd=2.2.5
VERSION-openssl=1.1.1k
VERSION-cfitsio=3450
VERSION-fftw2=2.1.5
VERSION-fftw3=3.3.8
PLATFORM-node=${GBP_NODE_PLATFORM}

# Set install directory
MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST)))
INSTALL_DIR = $(dir $(MAKEFILE_PATH))

####################
# Language Servers #
####################
lsp_list = luarocks dockerls bashls digestif ccls
.PHONY: lsps
lsps: ${lsp_list}

###############################################
## List of supported generic library targets ##
###############################################
generic_libs = lua bitop pyenv poetry rust openssl libsixel imgcat node libgit2 antibody zsh fzy ag ripgrep fzf neovim tree-sitter gcc cmake mpich gsl cfitsio gd fftw2 fftw3 $(lsp_list)

############################
## Generic library target ##
############################
.PHONY: $(generic_libs)
$(generic_libs): % : %-download %-config %-build %-install %-clean

#########################################
# Use this target to make all libraries #
#########################################
all: $(generic_libs)

##################################################################
## dockerls from HEAD                                           ##
## https://github.com/rcjsuen/dockerfile-language-server-nodejs ##
##################################################################
dockerls-download:
dockerls-config:
dockerls-build:
dockerls-install:
	@npm install -g dockerfile-language-server-nodejs
dockerls-clean:

######################################
## ccls from HEAD                   ##
##  https://github.com/MaskRay/ccls ##
######################################
ccls-download:
	@git clone --recursive https://github.com/MaskRay/ccls
ccls-config:
ccls-build:
	@cd ccls; mkdir build ; cd build ; cmake -DCMAKE_INSTALL_PREFIX:PATH=~/3rd_Party/ ..
ccls-install:
	@cd ccls/build; make install
ccls-clean:
	@rm -rf ccls
 
#############
## openssl ##
#############
openssl-download:
	@wget https://ftp.openssl.org/source/openssl-${VERSION-openssl}.tar.gz
openssl-config:
	@cd  openssl-${VERSION-openssl}; ./config --prefix=${INSTALL_DIR}/
openssl-build:
	@cd  openssl-${VERSION-openssl}; make
openssl-install:
	@cd  openssl-${VERSION-openssl}; make install
openssl-clean:
	@cd  openssl-${VERSION-openssl}; make clean

###########
## BitOP ##
###########
bitop-download:
	@wget http://bitop.luajit.org/download/LuaBitOp-${VERSION-bitop}.tar.gz
bitop-config:
bitop-build:
	@cd bitop-${VERSION-bitop}; make macosx
bitop-install:
	@cd bitop-${VERSION-bitop}; make install
bitop-clean:
	@cd bitop-${VERSION-bitop}; make clean

###########################################################
## bashls from HEAD                                      ##
## https://github.com/mads-hartmann/bash-language-server ##
###########################################################
bashls-download:
bashls-config:
bashls-build:
bashls-install:
	@npm install -g bash-language-server
bashls-clean:

###################
## Lua           ##
###################
lua-download:
	@curl -R -O http://www.lua.org/ftp/lua-${VERSION-lua}.tar.gz
lua-config:
	@tar zxf lua-${VERSION-lua}.tar.gz
lua-build:
	@cd lua-${VERSION-lua}; make all test
lua-install:
	@cd lua-${VERSION-lua}; make install INSTALL_TOP=${INSTALL_DIR}
lua-clean:
	@rm -rf lua

##################################
## luarocks from HEAD           ##
## (likely needed for digestif) ##
## https://luarocks.org/        ##
##################################
luarocks-download:
	@wget https://luarocks.github.io/luarocks/releases/luarocks-${VERSION-luarocks}.tar.gz
	@$(ECHO) Uncompressing ...;tar xzf luarocks-${VERSION-luarocks}.tar.gz ;$(ECHO) Done.
luarocks-config:
	@cd luarocks-${VERSION-luarocks};./configure --prefix=${INSTALL_DIR}/ 
luarocks-build:
	@cd luarocks-${VERSION-luarocks};make -j ${N_CORES}
luarocks-install:
	@cd luarocks-${VERSION-luarocks};make install
luarocks-clean:
	@rm -rf luarocks-${VERSION-luarocks}

########################################
## digestif from HEAD                 ##
## https://github.com/astoff/digestif ##
########################################
digestif-download:
digestif-config:
digestif-build:
digestif-install:
	@luarocks install digestif
digestif-clean:

### END OF LSP SERVERS ##

###########
## Pyenv ##
###########
pyenv-download:
pyenv-config:
pyenv-build:
pyenv-install:
	@git clone https://github.com/pyenv/pyenv.git ${GBP_HOME}/.pyenv
	@git clone https://github.com/pyenv/pyenv-virtualenv.git ${GBP_HOME}/.pyenv/plugins/pyenv-virtualenv
	@git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
pyenv-clean:

############
## Poetry ##
############
poetry-download:
poetry-config:
poetry-build:
poetry-install:
	@POETRY_HOME=${GBP_HOME} curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python3 -
poetry-clean:

####################
## Rust from HEAD ##
####################
rust-download:
rust-config:
rust-build:
rust-install:
	@curl https://sh.rustup.rs -sSf | sh
rust-clean:

####################
## node from HEAD ##
####################
node-download:
	@rm -rf node.js
	@wget http://nodejs.org/download/release/v${VERSION-node}/node-v${VERSION-node}-${PLATFORM-node}.tar.gz
node-config:
node-build:
node-install:
	@$(ECHO) Uncompressing ...;tar xzf node-v${VERSION-node}-${PLATFORM-node}.tar.gz ;$(ECHO) Done.
	@cd ${INSTALL_DIR};ln -s node-v${VERSION-node}-${PLATFORM-node} node.js
node-clean:
	@rm -rf build-node node-v${VERSION-node}-${PLATFORM-node}.tar.gz

###################
## fzf from HEAD ##
###################
fzf-download:
	@git clone --depth 1 https://github.com/junegunn/fzf.git ${GBP_HOME}/.fzf
fzf-config:
fzf-build:
fzf-install:
	@cd ${GBP_HOME}/.fzf;./install
fzf-clean:

###########################
## Tree-sitter from HEAD ##
###########################
tree-sitter-download:
tree-sitter-config:
tree-sitter-build:
tree-sitter-install:
	@cargo install tree-sitter-cli
tree-sitter-clean:

#######################
## Ripgrep from HEAD ##
#######################
ripgrep-download:
	@git clone https://github.com/BurntSushi/ripgrep ripgrep
ripgrep-config:
ripgrep-build:
	@cd ripgrep;cargo build --release
ripgrep-install:
ripgrep-clean:
#	@rm -rf ripgrep

###############################
## Silver Searcher from HEAD ##
###############################
ag-download:
	@git clone https://github.com/ggreer/the_silver_searcher ag
ag-config:
ag-build:
	@cd ag;./build.sh
ag-install:
	@cd ag;sudo make install
ag-clean:
	@rm -rf ag

###################
## fzy from HEAD ##
###################
fzy-download:
	@git clone https://github.com/jhawthorn/fzy
fzy-config:
fzy-build:
	@cd fzy;make -j ${N_CORES}
fzy-install:
	@cd fzy;PREFIX=${INSTALL_DIR}/ make install
fzy-clean:
	@rm -rf fzy

#######################################
## Neovim from HEAD                  ##
## n.b.: You might need to make sure ##
##       to have libtool installed   ## 
##       if linking against conda:   ##
##   > conda install libtool         ##
#######################################
neovim-download:
	@git clone https://github.com/neovim/neovim.git
neovim-config:
	@cd neovim; rm -rf build/  # clear the CMake cache
neovim-build:
	@cd neovim; make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/"
neovim-install:
	@cd neovim; make install
neovim-clean:
	@rm -rf neovim

#############
## libgit2 ##
#############
libgit2-download:
	@git clone https://github.com/libgit2/libgit2.git
libgit2-config:
libgit2-build:
	@cd libgit2; mkdir build ; cd build ; cmake -DCMAKE_INSTALL_PREFIX:PATH=~/3rd_Party/ ..
libgit2-install:
	@cd libgit2/build; make install
libgit2-clean:
	@rm -rf libgit2

##############
## antibody ##
##############
antibody_version = $(shell curl -s https://raw.githubusercontent.com/getantibody/homebrew-tap/master/Formula/antibody.rb | grep url | tail -n1 | cut -f8 -d'/')
antibody-download:
	@curl -s -L -o /tmp/antibody.tar.gz \
		https://github.com/getantibody/antibody/releases/download/$(antibody_version)/antibody_$(shell uname -s)_$(shell uname -m).tar.gz
antibody-config: antibody-download
antibody-build: antibody-config
	@$(ECHO) Uncompressing ...;tar xzf /tmp/antibody.tar.gz;$(ECHO) Done.
antibody-install: antibody-build
	@mv -f antibody ${INSTALL_DIR}/bin/
antibody-clean:
	@rm -rf antibody_install

########################
## libsixel from HEAD ##
########################
libsixel-download: 
	@git clone https://github.com/saitoha/libsixel
libsixel-config:
	@cd libsixel;autoconf
	@cd libsixel;./configure --prefix=${INSTALL_DIR}/
libsixel-build:
	@cd libsixel;make -j ${N_CORES}
libsixel-install:
	@cd libsixel;make install 
libsixel-clean:
	@rm -rf libsixel

######################
## imgcat from HEAD ##
######################
imgcat-download: 
	@git clone https://github.com/eddieantonio/imgcat
imgcat-config:
	@cd imgcat;autoconf
	@cd imgcat;./configure 
imgcat-build:
	@cd imgcat;make -j ${N_CORES}
imgcat-install:
	@cd imgcat;make install PREFIX=${INSTALL_DIR}/ 
imgcat-clean:
	@rm -rf imgcat

###################
## zsh from HEAD ##
###################
zsh-download: antibody
	@git clone git://zsh.git.sf.net/gitroot/zsh/zsh
zsh-config:
	@cd zsh;autoreconf
	@cd zsh;./configure --prefix=${INSTALL_DIR}/ 
zsh-build:
	@cd zsh;make -j ${N_CORES}
zsh-install:
	# Rather than 'make install', we list individual targets because I can't get install.man
	# or install.runhelp to work ... man pages are empty and an error results; ./help.txt is missing.
	@cd zsh;make install.bin install.modules install.fns
	@cd zsh;make check
zsh-clean:
	@rm -rf zsh

#########
## GCC ##
#########
gcc-download:
	@wget https://ftp.gnu.org/gnu/gcc/gcc-${VERSION-gcc}/gcc-${VERSION-gcc}.tar.gz
	@$(ECHO) Uncompressing ...;tar xzf gcc-${VERSION-gcc}.tar.gz;$(ECHO) Done.
	@cd gcc-${VERSION-gcc} ; $(ECHO) Downloading prerequisites... ; ./contrib/download_prerequisites;$(ECHO) Done.
gcc-config:
	@mkdir build-gcc
	@cd build-gcc;../gcc-${VERSION-gcc}/configure --prefix=${INSTALL_DIR}/ --enable-languages=c,c++ --disable-multilib
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
	@cd build-cmake;../cmake-${VERSION-cmake}/bootstrap --prefix=${INSTALL_DIR}
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
        	--prefix=${INSTALL_DIR}                 \
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
	@cd build-gsl;../gsl-${VERSION-gsl}/configure --prefix=${INSTALL_DIR}/
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
	@cd cfitsio;../cfitsio/configure --prefix=${INSTALL_DIR}/
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
	@cd build-gd;../libgd-${VERSION-gd}/configure --prefix=${INSTALL_DIR}/
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
	@cd build-fftw2-sp;../fftw-${VERSION-fftw2}/configure --enable-type-prefix --prefix=${INSTALL_DIR}/ --enable-float
	@cd build-fftw2-dp;../fftw-${VERSION-fftw2}/configure --enable-type-prefix --prefix=${INSTALL_DIR}/ 
	@cd build-fftw2-sp-mpi;../fftw-${VERSION-fftw2}/configure --enable-type-prefix --prefix=${INSTALL_DIR}/ --enable-mpi --enable-float
	@cd build-fftw2-dp-mpi;../fftw-${VERSION-fftw2}/configure --enable-type-prefix --prefix=${INSTALL_DIR}/ --enable-mpi
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

###########
## FFTW3 ##
###########
fftw3-download:
	@wget http://www.fftw.org/fftw-${VERSION-fftw3}.tar.gz
	@tar xzf fftw-${VERSION-fftw3}.tar.gz
fftw3-config:
	@mkdir build-fftw3-sp
	@mkdir build-fftw3-dp
	@mkdir build-fftw3-sp-mpi
	@mkdir build-fftw3-dp-mpi
	@cd build-fftw3-sp;../fftw-${VERSION-fftw3}/configure --prefix=${INSTALL_DIR}/ --enable-float
	@cd build-fftw3-dp;../fftw-${VERSION-fftw3}/configure --prefix=${INSTALL_DIR}/ 
	@cd build-fftw3-sp-mpi;../fftw-${VERSION-fftw3}/configure --prefix=${INSTALL_DIR}/ --enable-mpi --enable-float
	@cd build-fftw3-dp-mpi;../fftw-${VERSION-fftw3}/configure --prefix=${INSTALL_DIR}/ --enable-mpi
fftw3-build:
	@cd build-fftw3-sp;make -j 4
	@cd build-fftw3-dp;make -j 4
	@cd build-fftw3-sp-mpi;make -j 4
	@cd build-fftw3-dp-mpi;make -j 4
fftw3-install:
	@cd build-fftw3-sp;make install
	@cd build-fftw3-dp;make install
	@cd build-fftw3-sp-mpi;make install
	@cd build-fftw3-dp-mpi;make install
fftw3-clean:
	@rm -rf build-fftw3* fftw-${VERSION-fftw}*

##############
# Print help #
##############
help:
	@$(ECHO) 
	@$(ECHO) "The following targets are available:"
	@$(ECHO) "    all     - Make all the libraries listed below."
	@$(ECHO) "    zsh     - Install ZSH     version: "${VERSION-zsh}
	@$(ECHO) "    gcc     - Install GCC     version: "${VERSION-gcc}    " (takes ~2 hr)"
	@$(ECHO) "    cmake   - Install CMAKE   version: "${VERSION-cmake}
	@$(ECHO) "    mpich   - Install MPICH   version: "${VERSION-mpich}  " (takes ~2 hr)"
	@$(ECHO) "    gsl     - Install GSL     version: "${VERSION-gsl}
	@$(ECHO) "    cfitsio - Install cfitsio version: "${VERSION-cfitsio}
	@$(ECHO) "    gd      - Install libgd   version: "${VERSION-gd}
	@$(ECHO) "    fftw2   - Install FFTW    version: "${VERSION-fftw2}
	@$(ECHO) 
