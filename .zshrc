# This file is largely that of: https://github.com/tonylambiris/dotfiles/blob/master/dot.zshrc

# Set this variable to '1' to perform profiling of zsh startup
export ZSH_PROFILE_MODE=0
if [ $ZSH_PROFILE_MODE -eq 1 ]; then
    zmodload zsh/zprof
fi

# Ensure that zplug is installed
[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh

# zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# oh-my-zsh -- makes several important plugins available
zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh"

# Miscellaneous commands
zplug "k4rthik/git-cal",  as:command
zplug "supercrabtree/k",  use:k.sh

# Filters
zplug "peco/peco",    as:command, from:gh-r
zplug "junegunn/fzf", use:"shell/*.zsh", as:plugin
zplug "aperezdc/zsh-fzy"

# Enhancd 
zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/zsh-history-enhanced"

# Bookmarks and jump
#zplug "jocelynmallon/zshmarks"

# Jump back to parent directory
#zplug "tarrasch/zsh-bd", use:bd.zsh

# Directory colors
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin

# Load theme
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

zplug "plugins/common-aliases",    from:oh-my-zsh
zplug "plugins/history",           from:oh-my-zsh
#zplug "plugins/tmux",              from:oh-my-zsh
#zplug "plugins/tmuxinator",        from:oh-my-zsh
zplug "plugins/web-search",        from:oh-my-zsh
zplug "plugins/taskwarrior",       from:oh-my-zsh

# Supports oh-my-zsh plugins and the like
if [[ $OSTYPE = (linux)* ]]; then
    zplug "plugins/archlinux",     from:oh-my-zsh, if:"(( $+commands[pacman] ))"
    zplug "plugins/dnf",           from:oh-my-zsh, if:"(( $+commands[dnf] ))"
fi

if [[ $OSTYPE = (darwin)* ]]; then
    zplug "lib/clipboard",         from:oh-my-zsh
    zplug "plugins/osx",           from:oh-my-zsh
    zplug "plugins/brew",          from:oh-my-zsh, if:"(( $+commands[brew] ))"
fi

zplug "plugins/git",               from:oh-my-zsh, if:"(( $+commands[git] ))"
zplug "plugins/npm",               from:oh-my-zsh, if:"(( $+commands[npm] ))"
zplug "plugins/pip",               from:oh-my-zsh, if:"(( $+commands[pip] ))"
zplug "plugins/sudo",              from:oh-my-zsh, if:"(( $+commands[sudo] ))"
zplug "plugins/gpg-agent",         from:oh-my-zsh, if:"(( $+commands[gpg-agent] ))"
zplug "plugins/docker",            from:oh-my-zsh, if:"(( $+commands[docker] ))"
zplug "plugins/docker-compose",    from:oh-my-zsh, if:"(( $+commands[docker-compose] ))"

# Autocompletion/suggestion stuff
zplug "djui/alias-tips"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"

# zsh-syntax-highlighting must be loaded after executing compinit command
# and sourcing other plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# =============================================================================
#                                   Options
# =============================================================================

# Key timeout and character sequences
KEYTIMEOUT=1
WORDCHARS='*?_-[]~=./&;!#$%^(){}<>'

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt autocd                   # Allow changing directories without `cd`
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_all_dups     # Remember only one unique copy of the command.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.
setopt hist_ignore_space        # Ignore commands that start with space.

# Changing directories
#setopt auto_pushd
setopt pushd_ignore_dups        # Dont push copies of the same dir on stack.
setopt pushd_minus              # Reference stack entries with "-".

setopt extended_glob

## =============================================================================
##                                   Aliases
## =============================================================================
#
## In the definitions below, you will see use of function definitions instead of
## aliases for some cases. We use this method to avoid expansion of the alias in
## combination with the globalias plugin.
#
## Directory coloring
#if [[ $OSTYPE = (darwin|freebsd)* ]]; then
#	export CLICOLOR="YES" # Equivalent to passing -G to ls.
#	export LSCOLORS="exgxdHdHcxaHaHhBhDeaec"
#
#	[ -d "/opt/local/bin" ] && export PATH="/opt/local/bin:$PATH"
#
#	# Prefer GNU version, since it respects dircolors.
#	if (( $+commands[gls] )); then
#		alias ls='() { $(whence -p gls) -Ctr --file-type --color=auto $@ }'
#	else
#		alias ls='() { $(whence -p ls) -CFtr $@ }'
#	fi
#else
#	alias ls='() { $(whence -p ls) -Ctr --file-type --color=auto $@ }'
#fi
#
## Set editor preference to nvim if available.
#if (( $+commands[nvim] )); then
#	alias vim='() { $(whence -p nvim) $@ }'
#else
#	alias vim='() { $(whence -p vim) $@ }'
#fi
#
## Generic command adaptations
#alias grep='() { $(whence -p grep) --color=auto $@ }'
#alias egrep='() { $(whence -p egrep) --color=auto $@ }'
#
## Custom helper aliases
#alias ccat='highlight -O ansi'
#alias rm='rm -v'
#
## Directory management
#alias la='ls -a'
#alias ll='ls -l'
#alias lal='ls -al'
#alias d='dirs -v'
#alias 1='pu'
#alias 2='pu -2'
#alias 3='pu -3'
#alias 4='pu -4'
#alias 5='pu -5'
#alias 6='pu -6'
#alias 7='pu -7'
#alias 8='pu -8'
#alias 9='pu -9'
#alias pu='() { pushd $1 &> /dev/null; dirs -v; }'
#alias po='() { popd &> /dev/null; dirs -v; }'
#
#zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

## =============================================================================
##                                Key Bindings
## =============================================================================
#
## Common CTRL bindings.
#bindkey "^a" beginning-of-line
#bindkey "^e" end-of-line
#bindkey "^f" forward-word
#bindkey "^b" backward-word
#bindkey "^k" kill-line
#bindkey "^d" delete-char
#bindkey "^y" accept-and-hold
#bindkey "^w" backward-kill-word
#bindkey "^u" backward-kill-line
#bindkey "^R" history-incremental-pattern-search-backward
#bindkey "^F" history-incremental-pattern-search-forward
#
## Do not require a space when attempting to tab-complete.
#bindkey "^i" expand-or-complete-prefix
#
## Fixes for alt-backspace and arrows keys
#bindkey '^[^?' backward-kill-word
#bindkey "^[[1;5C" forward-word
#bindkey "^[[1;5D" backward-word
##bindkey "^[[C" forward-word
##bindkey "^[[D" backward-word
#
### Emulate tcsh's backward-delete-word
##tcsh-backward-kill-word () {
##    local WORDCHARS="${WORDCHARS:s#/#}"
##    zle backward-kill-word
##}
##zle -N tcsh-backward-kill-word
#
## https://github.com/sickill/dotfiles/blob/master/.zsh.d/key-bindings.zsh
#tcsh-backward-word () {
#  local WORDCHARS="${WORDCHARS:s#./#}"
#  zle emacs-backward-word
#}
#zle -N tcsh-backward-word
#bindkey '\e[1;3D' tcsh-backward-word
#bindkey '\e^[[D' tcsh-backward-word # tmux
#
#tcsh-forward-word () {
#  local WORDCHARS="${WORDCHARS:s#./#}"
#  zle emacs-forward-word
#}
#zle -N tcsh-forward-word
#bindkey '\e[1;3C' tcsh-forward-word
#bindkey '\e^[[C' tcsh-backward-word # tmux
#
#tcsh-backward-delete-word () {
#  local WORDCHARS="${WORDCHARS:s#./#}"
#  zle backward-delete-word
#}
#zle -N tcsh-backward-delete-word
#bindkey "^[^?" tcsh-backward-delete-word # urxvt

# =============================================================================
#                                 Completions
# =============================================================================

zstyle ':completion:*' rehash true
#zstyle ':completion:*' verbose yes
#zstyle ':completion:*:descriptions' format '%B%d%b'
#zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
#zstyle ':completion:*' group-name ''

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

# =============================================================================
#                                   Startup
# =============================================================================

# Load SSH and GPG agents via keychain.
setup_agents() {
  [[ $UID -eq 0 ]] && return

  if (( $+commands[keychain] )); then
	local -a ssh_keys gpg_keys
	for i in ~/.ssh/**/*pub; do test -f "$i(.N:r)" && ssh_keys+=("$i(.N:r)"); done
	gpg_keys=$(gpg -K --with-colons 2>/dev/null | awk -F : '$1 == "sec" { print $5 }')
    if (( $#ssh_keys > 0 )) || (( $#gpg_keys > 0 )); then
	  alias run_agents='() { $(whence -p keychain) --quiet --eval --inherit any-once --agents ssh,gpg $ssh_keys ${(f)gpg_keys} }'
	  #[[ -t ${fd:-0} || -p /dev/stdin ]] && eval `run_agents`
	  unalias run_agents
    fi
  fi
}
setup_agents
unfunction setup_agents

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

if zplug check "seebi/dircolors-solarized"; then
  which gdircolors &> /dev/null && alias dircolors='() { $(whence -p gdircolors) }'
  which dircolors &> /dev/null && \
	  eval $(dircolors ~/.zplug/repos/seebi/dircolors-solarized/dircolors.256dark)
fi

if zplug check "zsh-users/zsh-history-substring-search"; then
	zmodload zsh/terminfo
	bindkey "$terminfo[kcuu1]" history-substring-search-up
	bindkey "$terminfo[kcud1]" history-substring-search-down
	bindkey "^[[1;5A" history-substring-search-up
	bindkey "^[[1;5B" history-substring-search-down
fi

if zplug check "zsh-users/zsh-syntax-highlighting"; then
	#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line)
	ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

	typeset -A ZSH_HIGHLIGHT_STYLES
	ZSH_HIGHLIGHT_STYLES[cursor]='bg=yellow'
	ZSH_HIGHLIGHT_STYLES[globbing]='none'
	ZSH_HIGHLIGHT_STYLES[path]='fg=white'
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=grey'
	ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[function]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[command]='fg=green'
	ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
	ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
	ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
fi

if zplug check "b4b4r07/enhancd"; then
    ENHANCD_DOT_SHOW_FULLPATH=1
	ENHANCD_DISABLE_HOME=1
fi

if zplug check "b4b4r07/zsh-history-enhanced"; then
    ZSH_HISTORY_FILTER="fzy:fzf:peco:percol"
    ZSH_HISTORY_KEYBIND_GET_BY_DIR="^r"
    ZSH_HISTORY_KEYBIND_GET_ALL="^r^a"
fi

if zplug check "bhilburn/powerlevel9k"; then
    # Easily switch primary foreground/background colors
    DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=235
    DEFAULT_COLOR=$DEFAULT_FOREGROUND

    # Set name of the theme to load --- if set to "random", it will
    # load a random theme each time oh-my-zsh is loaded, in which case,
    # to know which specific one was loaded, run: echo $RANDOM_THEME
    # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
    #ZSH_THEME="agnoster"
    #ZSH_THEME="powerlevel9k/powerlevel9k"
    POWERLEVEL9K_MODE='nerdfont-complete'
    POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
    POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
    
    POWERLEVEL9K_HOME_ICON=''
    POWERLEVEL9K_HOME_SUB_ICON=''
    POWERLEVEL9K_FOLDER_ICON=''
    POWERLEVEL9K_ETC_ICON=''
    POWERLEVEL9K_HOME_FOLDER_ABBREVIATION="\uF015 "
    
    POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
    POWERLEVEL9K_SHORTEN_DELIMITER=".."
    POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
    
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir anaconda pyenv vcs dir_writable)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time history time)
    
    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='190'
    POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='176'
    
    POWERLEVEL9K_MODE='nerdfont-complete'

    # powerlevel9k prompt theme
    #DEFAULT_USER=$USER

    #POWERLEVEL9K_SHORTEN_STRATEGY="truncate_right"

    #POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=false

    POWERLEVEL9K_ALWAYS_SHOW_USER=false

    POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109 %m"

    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4"
    POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
    POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6"
    POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

    POWERLEVEL9K_STATUS_VERBOSE=true
    POWERLEVEL9K_STATUS_CROSS=true

    #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{cyan}\u256D\u2500%f"
    #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{014}\u2570%F{cyan}\uF460%F{073}\uF460%F{109}\uF460%f "
    #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─%f"
    #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰─%F{008}\uF460 %f"
    #POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
    #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{008}> %f"

    POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭"
    #POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="❱ "
    POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰\uF460 "

    POWERLEVEL9K_VCS_CLEAN_BACKGROUND="green"
    POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="yellow"
    POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="magenta"
    POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_DIR_HOME_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_HOME_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_STATUS_OK_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
    POWERLEVEL9K_STATUS_OK_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_STATUS_OK_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

    POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"

    POWERLEVEL9K_HISTORY_FOREGROUND="$DEFAULT_FOREGROUND"

    POWERLEVEL9K_TIME_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_TIME_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_VCS_GIT_GITHUB_ICON=""
    POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=""
    POWERLEVEL9K_VCS_GIT_GITLAB_ICON=""
    POWERLEVEL9K_VCS_GIT_ICON=""

    POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"

    #POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
    #POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0

    POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$DEFAULT_FOREGROUND"

    POWERLEVEL9K_USER_ICON="\uF415" # 
    POWERLEVEL9K_USER_DEFAULT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_USER_DEFAULT_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_USER_ROOT_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_USER_ROOT_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="magenta"
    POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
    POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
    #POWERLEVEL9K_ROOT_ICON=$'\uFF03' # ＃
    POWERLEVEL9K_ROOT_ICON=$'\uF198'  # 

    POWERLEVEL9K_SSH_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_SSH_FOREGROUND="yellow"
    POWERLEVEL9K_SSH_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_SSH_BACKGROUND="$(( $DEFAULT_BACKGROUND + 2 ))"
    POWERLEVEL9K_SSH_BACKGROUND="$(( $DEFAULT_BACKGROUND - 2 ))"
    POWERLEVEL9K_SSH_ICON="\uF489"  # 

    POWERLEVEL9K_HOST_LOCAL_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_HOST_LOCAL_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_HOST_REMOTE_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_HOST_REMOTE_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_HOST_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_HOST_ICON_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_HOST_ICON="\uF109" # 

    POWERLEVEL9K_OS_ICON_FOREGROUND="$DEFAULT_FOREGROUND"
    POWERLEVEL9K_OS_ICON_BACKGROUND="$DEFAULT_BACKGROUND"

    POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_LOAD_WARNING_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="red"
    POWERLEVEL9K_LOAD_WARNING_FOREGROUND="yellow"
    POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="green"
    POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
    POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
    POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="green"

    POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND_COLOR="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="$DEFAULT_BACKGROUND"
    POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="$DEFAULT_BACKGROUND"
fi

# Then, source plugins and add commands to $PATH
zplug load

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

## Oh-my-zsh plugins
#plugins=(
#  git
#  taskwarrior
#  colorize
#  tmux
#)

# User configuration
source $PWD/.bashrc

# Report profiling
if [ $ZSH_PROFILE_MODE -eq 1 ]; then
    zprof
fi
