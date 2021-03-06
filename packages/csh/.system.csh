
# Decide what sort of system we're on
if ( -f /bin/uname ||  -f /usr/bin/uname ) then
  setenv GBP_OS `uname`
  if ( $GBP_OS == 'Darwin') then
     setenv GBP_OS 'Mac'
  else if ($GBP_OS == 'Linux') then
     setenv GBP_OS 'linux'
  else
     setenv GBP_OS 'unknown'
  endif
else
  setenv GBP_OS 'unknown'
endif

# Set system-specific stuff, first based on HOSTNAME 
setenv GBP_HOSTNAME `hostname`
if ( $?GBP_HOSTNAME ) then
  if ( $GBP_HOSTNAME == 'Terminal-2.local' ) then
    setenv GBP_QUEUE_TYPE 'NONE'
    setenv PATH /anaconda/bin:$PATH
  else if ( $GBP_HOSTNAME == 'green.ssi.swin.edu.au' ) then
    setenv GBP_QUEUE_TYPE 'PBS'
    source /usr/local/Modules/default/init/modules.csh
    module load anaconda
    module load hdf5/gnu-1.8.6
    module load git/1.7.4
    module load gsl
  else if ( $GBP_HOSTNAME == 'epicuser1' ) then
    setenv GBP_QUEUE_TYPE 'PBS'
    module load gcc/4.4.6
    module load mpi/gcc/openmpi/1.4.3-gcc-4.4.6
    module load python
    module load fftw/2.1.5
    module load hdf5/1.8.7-gcc-4.4.6-fortran-parallel-static
    module load gsl
  else if ( $GBP_HOSTNAME == 'vayu3' ) then
    setenv GBP_QUEUE_TYPE 'PBS'
    module load gcc/system
    module load openmpi
    module load python
    module load fftw2/2.1.5
    module load hdf5
    module load gsl
  else if ( $GBP_HOSTNAME == 'g2.hpc.swin.edu.au' ) then
    setenv GBP_QUEUE_TYPE 'PBS'
    source /usr/local/modules/init/tcsh
    module unload gcc openmpi gsl fftw hdf5
    module   load gcc openmpi/x86_64/gnu/1.8.3 gsl fftw hdf5 anaconda
  else if ( $GBP_HOSTNAME == 'sstar001.hpc.swin.edu.au' ) then
    setenv GBP_QUEUE_TYPE 'NONE'
    source /usr/local/modules/init/tcsh
    module unload gcc openmpi gsl fftw hdf5
    module   load gcc openmpi/x86_64/gnu/1.8.3 gsl fftw hdf5 anaconda
  else if ( $GBP_HOSTNAME == 'sstar002.hpc.swin.edu.au' ) then
    setenv GBP_QUEUE_TYPE 'NONE'
    source /usr/local/modules/init/tcsh
    module unload gcc openmpi/x86_64/gnu/1.8.3 gsl fftw hdf5
    module   load gcc openmpi/x86_64/gnu/1.8.3 gsl fftw hdf5
  else if ( $GBP_OS == 'Mac' ) then
    setenv GBP_QUEUE_TYPE 'SERIAL'
    # Make sure ._* files don't get added to tar files, etc.
    setenv COPYFILE_DISABLE 1
    setenv PATH /opt/local/bin:/opt/local/sbin:$PATH
  else
    echo There is no default configuration in .system.cshrc for this system.  Assigning defaults.
    setenv GBP_QUEUE_TYPE 'SERIAL'
  endif
else if ( $GBP_OS == 'Mac' ) then
   setenv GBP_QUEUE_TYPE 'SERIAL'
   setenv PATH /opt/local/bin:/opt/local/sbin:$PATH
else
   echo There is no default configuration in .system.cshrc for this system.  Assigning defaults.
   setenv GBP_QUEUE_TYPE 'SERIAL'
endif

# Set-up some stuff on Macs
# RUNZ_PROJECT=2 is LRG mode
if ( $GBP_OS == 'Mac' ) then
  setenv RUNZ         '/Applications/runz/'
  setenv RUNZ_PROJECT 2
  setenv PGPLOT_DIR   /Users/gpoole/3rd_Party/pgplot/lib
  setenv PGPLOT_FONT  /Users/gpoole/3rd_Party/pgplot/lib/grfont.dat
endif

