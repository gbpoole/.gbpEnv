#!/bin/bash
# vim:syntax=sh
# vim:filetype=sh

# Set prompt, unless terminal is 'dumb'
if [ -z ${TERM+x} -o "$TERM" = "dumb" ]; then
    [ $(alias | grep "setprompt" | wc -l) != 0 ] && unalias setprompt
elif [ ! -n "$ZSH_VERSION" ]; then
    # Set control sequences for prompt
    # pmt_black=$(tput setaf   0)
    pmt_red=$(tput setaf     1)
    pmt_green=$(tput setaf   2)
    pmt_blue=$(tput setaf    4)
    pmt_magenta=$(tput setaf 5)
    pmt_cyan=$(tput setaf    6)
    pmt_reset=$(tput sgr0)
    pmt_hst=$(hostname -s)
    pmt_usr=$(who am i | awk '{print $1}')
 
    # Set terminal prompt color
    if [ "$GBPDOCKER_ENV" = "ON" ]; then
        export pmt_colour=$pmt_cyan
        export usr_colour=$pmt_blue
    else
        export pmt_colour=$pmt_red
        export usr_colour=$pmt_magenta
    fi
 
    # Define the CLI prompt
    if [ "$pmt_usr" = "gpoole" ] || [ "$pmt_usr" = "gbpoole" ]; then
        alias setprompt='export PS1="${pmt_colour}[${pmt_hst}: \W] > ${pmt_reset}"'
    else
        alias setprompt='export PS1="${pmt_colour}[${usr_colour}${pmt_usr}@${pmt_colour}${pmt_hst}: \W] > ${pmt_reset}"'
    fi
fi

# --- Add color to some things ---

# history
export HISTTIMEFORMAT="$pmt_green%d/%m/%y $pmt_blue%T$pmt_reset "

# grep
export GREP_COLOR='0;33'
alias grep='grep --color=auto'

# pagers
if [ -e $GBP_HOME/3rd_Party/bin/vimpager ]; then
   export GBP_PAGER="$GBP_HOME/3rd_Party/bin/vimpager -N"
else
   export GBP_PAGER=$(which more)
fi
if [ -e $GBP_HOME/3rd_Party/bin/vimcat ]; then
   export GBP_CAT=$GBP_HOME/3rd_Party/bin/vimcat
else
   export GBP_CAT=$(which cat)
fi
alias more=$GBP_PAGER
alias cat=$GBP_CAT

# ls
if [ "$GBP_OS" = 'Mac' ]; then
    if [ -e '/usr/local/bin/gls' ]; then
        alias ls='/usr/local/bin/gls --color=auto'
    else
        alias ls='ls -C'
    fi
else
    alias ls='ls -C --color=auto'
fi

# Git aliases
alias g='git'
alias gdiff='git diff'
alias gst='git status'
alias glg='git lg | head'

# Make sure the pip in the current environment is always used
alias pip='python -m pip'

# Substitute for a few improved applications, if present

# 'top'->'htop'
if hash htop 2>/dev/null; then
   alias top='htop'
fi

# 'nvim' or 'vim'->'vi'
if hash nvim 2>/dev/null; then
   alias vi='nvim'
elif hash vim 2>/dev/null; then
   alias vi='vim'
fi

# Override the XCode install of gcc
if [ "$GBP_OS" = 'Mac' ]; then
   alias gcc='gcc-7'
fi

# Slurm stuff
alias squeue='squeue -o "%.18i %.9P %.8j %.8u %.6D %.6C %.11M %.11l %.8T %R"'
alias squeue_me='squeue -o "%.18i %.9P %.8j %.8u %.6D %.6C %.11M %.11l %.8T %R" -u gpoole'

# List of machines
alias go_alibaba='ssh -t -Y -l nonroot 106.15.109.75 "cd .gbpEnv; bash --rcfile .bashrc"'
alias go_krill='ssh -Y -l gbpoole krill.phys.uvic.ca'
alias go_turbot='ssh -Y -l gbpoole turbot.phys.uvic.ca'
alias go_chinook='ssh -Y -l gbpoole chinook.phys.uvic.ca'
alias go_green='ssh -Y -l gpoole lightgreen.ssi.swin.edu.au'
alias go_Green='ssh -Y -l gpoole green.ssi.swin.edu.au'
alias go_epic='ssh -Y -l gpoole epic.ivec.org'
alias go_vayu='ssh -Y -l gbp593 vayu.nci.org.au'
alias go_asv1='ssh -Y -l gpoole asv1.cc.swin.edu.au'
alias go_gstar='ssh -Y -l gpoole g2'
if [ "$GBP_HOSTNAME" = 'g2.hpc.swin.edu.au' ]; then
   alias go_sstar1='ssh -Y -l gpoole  sstar001'
   alias go_sstar2='ssh -Y -l gpoole  sstar002'
   alias go_sstar3='ssh -Y -l gpoole  sstar003'
   alias go_tao02='ssh -t -Y -l TAODBAdmin tao02 "cd /lustre/projects/p014_swin/gpoole; bash --rcfile .bashrc"'
else
   alias go_gstar='ssh -Y -l gpoole  gstar_pf'
   alias go_sstar1='ssh -Y -l gpoole  sstar001_pf'
   alias go_sstar2='ssh -Y -l gpoole  sstar002_pf'
   alias go_sstar3='ssh -Y -l gpoole  sstar003_pf'
   alias go_tao02='ssh -t -Y -l TAODBAdmin tao02_pf "cd /lustre/projects/p014_swin/gpoole; bash --rcfile .bashrc"'
fi

alias go_oz='set_iterm2_tab_name oz;ssh -Y -l gpoole oz;unset_iterm2_tab_name'
alias go_f1='set_iterm2_tab_name f1;ssh -Y -l gpoole f1;unset_iterm2_tab_name'
alias go_f2='set_iterm2_tab_name f2;ssh -Y -l gpoole f2;unset_iterm2_tab_name'

# Update gbpEnv install
alias gbpEnv_update='cd $GBP_HOME;make -f .gbpEnv/Makefile update'

# Perform a timing test of shell start-up
alias time_shell_startup='for i in $(seq 1 10); do /usr/bin/time /bin/zsh -i -c exit; done;'

# Useful commands to remember
alias compress_ps='gs -q -dLEVEL3 -dASCII -- ${GBP_HOME}/bin/encode.ps $1 $2'

# Mac aliases
if [ "$GBP_OS" = 'Mac' ]; then
   alias runz='/Applications/runz/runz'
   alias rz_completeness='/Applications/runz/rz_completeness.pl'
   export RUNZ='/Applications/runz/'
   # Aliases for starting/stopping the Homebrew install of PostgreSQL
   alias pg-start="launchctl load ${GBP_HOME}/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
   alias pg-stop="launchctl unload ${GBP_HOME}/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
fi

# Some stuff particular to having PBS
if [ "$GBP_QUEUE_TYPE" = 'PBS' ]; then
   alias qstat_me='qstat -n1 -u '$USER
   alias qsm='qstat_me'
fi

# Some Anaconda stuff
alias conda.list='conda info --envs'
alias conda.unload='conda deactivate'

#
# Define common system-wide configurations

alias ll='ls -lFh'     			# long (-l), types classify (-F),human readable (-h)
alias l='ll'
alias ls.all='ls -lAFh' 		# long list, show almost all
alias ls.sort.time='ls -tlFh'
alias ls.sort.size='ls -SlFh'
alias ls.dot='ls -ld .*'		# show dot files, list dirs non-recursively (-d)
alias ls.recursive='ls -R'
alias ls.id='ls -nFh'			# show numeric FID and GID (-n)

# diff
alias diff='colordiff'

# change dir
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../..'

alias df='df -h'

#
# Pipe Aliases
#
alias grep='egrep --color=auto '
alias egrep='egrep --color=auto '
alias L=' | less '
alias G=' | egrep --color=auto '
alias T=' | tail '
alias H=' | head '
alias W=' | wc -l '
alias S=' | sort '

#function handle-multi-arguments(){
#	if [ ! "$#" -gt 1 ] ; then
#	  echo "Usage: $0 file1 file2 ..." >&2
#	  return -1
#	fi
#	for file in $@; do
#		if [ -f $file ] ; then
#			echo -n $file
#		fi
#	done
#	echo 'Done!'
#}

# macOS specific
#
# Check if running on macOS, otherwise stop here
[[ ! "$(uname -s)" == "Darwin" ]] && return

# /etc/zprofile is loaded and invokes
# /usr/libexec/path_helper that might slow down start-up.
# Better enter directly the content of /etc/paths.d here

# /etc/paths.d/40-XQuartz
export PATH=$PATH:/opt/X11/bin

# /etc/paths.d/MacGPG2
export PATH=$PATH:/usr/local/MacGPG2/bin

#
# GNU Core Utils
# brew info coreutils
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

# scutil
#
alias sys.get.computername='scutil --get ComputerName'
alias sys.get.localhostname='scutil --get LocalHostName'
alias sys.get.hostname='scutil --get HostName'
alias sys.get.dns='scutil --dns'
alias sys.get.proxy='scutil --proxy'
alias sys.get.network.interface='scutil --nwi'

#
alias sys.uti.file='mdls -name kMDItemContentTypeTree '

alias lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'
#
# OS X's launchctl
#
alias launch.list='launchctl list '
alias launch.load='launchctl load '
alias launch.unload='launchctl unload '
alias launch.getenv='launchctl getenv '
alias launch.start='launchctl start '
alias launch.stop='launchctl stop '

#
# Spotlight / Meta-data indexing (MDS)
#
# https://apple.stackexchange.com/q/87090/7647
# https://apple.stackexchange.com/q/63178/7647
#
alias spotlight.exclusion.show='sudo defaults read /.Spotlight-V100/VolumeConfiguration.plist Exclusions'
alias spotlight.exclusion.add='sudo defaults write /.Spotlight-V100/VolumeConfiguration.plist Exclusions -array-add '

alias spotlight.indexing.stop='sudo launchctl stop com.apple.metadata.mds'
alias spotlight.indexing.start='sudo launchctl start com.apple.metadata.md'
alias spotlight.indexing.restart='spotlight.indexing.stop && spotlight.indexing.start'

alias sys.pkg.list='pkgutil --pkgs'

# show CPU info
alias sys.cpu='sysctl -n machdep.cpu.brand_string'

# Make sure that the aliases created here are available immediately to any scripts that source this file
if [ ! -n "$ZSH_VERSION" ]; then
   shopt -s expand_aliases
fi
