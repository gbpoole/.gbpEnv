#!/bin/tcsh -f

# Generic UNIX aliases
alias setprompt  'set prompt = "\n%{\033[31m%}[`hostname -s`: %c] >%{\033[0m%} "'
alias cd         'chdir \!* && setprompt'
if ( $GBP_OS == 'Mac' ) then
   alias ls         'ls -CG'
   alias lsl        'ls -CGlhrt'
else
   alias ls         'ls -CG --color=auto'
   alias lsl        'ls -CGlhrt --color=auto'
endif

alias top 'htop'

# List of machines
alias go_krill    'ssh -Y -l gbpoole krill.phys.uvic.ca'
alias go_turbot   'ssh -Y -l gbpoole turbot.phys.uvic.ca'
alias go_chinook  'ssh -Y -l gbpoole chinook.phys.uvic.ca'
alias go_vayu     'ssh -Y -l gbp593  vayu.nci.org.au'
alias go_avoca    'ssh -Y -l gpoole  avoca.vlsci.unimelb.edu.au'
alias go_baker    'ssh -Y -l gpoole  baker.ph.unimelb.edu.au'
if ( $GBP_HOSTNAME == 'g2.hpc.swin.edu.au' ) then
   alias go_sstar1   'ssh -Y -l gpoole  sstar001'
   alias go_sstar2   'ssh -Y -l gpoole  sstar002'
   alias go_sstar3   'ssh -Y -l gpoole  sstar003'
else
   alias go_gstar    'ssh -Y -l gpoole  gstar_pf'
   alias go_sstar1   'ssh -Y -l gpoole  sstar001_pf'
   alias go_sstar2   'ssh -Y -l gpoole  sstar002_pf'
   alias go_sstar3   'ssh -Y -l gpoole  sstar003_pf'
endif


# Useful commands to remember
alias compress_ps 'gs -q -dLEVEL3 -dASCII -- ~/bin/encode.ps $1 $2'

alias start_sshuttle '~/3rd_Party/sshuttle/sshuttle -r gpoole@baker.ph.unimelb.edu.au 0.0.0.0/0 -vv'

# Add this to URLs to be able to download pdfs from ADS

alias ADS_URL 'echo .ezp.lib.unimelb.edu.au'

# Mac aliases
if ( $GBP_OS == 'Mac' ) then
   alias runz            /Applications/runz/runz
   alias rz_completeness /Applications/runz/rz_completeness.pl
endif

# Some stuff particular to having PBS
if ( $GBP_QUEUE_TYPE == 'PBS' ) then
  alias qstat_me 'qstat -n1 -u '$USER
  alias qsm      qstat_me
endif

