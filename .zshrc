#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

export TERM="xterm-256color"

# Set this variable to '1' to perform profiling of zsh startup
export ZSH_PROFILE_MODE=0
if [ $ZSH_PROFILE_MODE -eq 1 ]; then
    zmodload zsh/zprof
fi

export SCRIPTS=${HOME}/scripts

export ZSHCONFIG=${HOME}/.zsh-config

ZSH_INIT=${ZSHCONFIG}/_init.sh

<<<<<<< HEAD
# Miscellaneous commands
#zplug "k4rthik/git-cal",  as:command
#zplug "supercrabtree/k",  use:k.sh

# Add 3rd_Party/bin to the path because fzy needs it
export PATH="/home/gpoole/3rd_Party/bin:$PATH"

# Filters
zplug "peco/peco",    as:command, from:gh-r
zplug "junegunn/fzf", use:"shell/*.zsh", as:plugin
zplug "aperezdc/zsh-fzy"

# Enhancd 
zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/zsh-history-enhanced"

# Directory colors
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin

# Load theme
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

zplug "plugins/common-aliases",    from:oh-my-zsh
zplug "plugins/taskwarrior",       from:oh-my-zsh
zplug "plugins/git",               from:oh-my-zsh, if:"(( $+commands[git] ))"
#zplug "plugins/history",           from:oh-my-zsh
#zplug "plugins/tmux",              from:oh-my-zsh
#zplug "plugins/tmuxinator",        from:oh-my-zsh
#zplug "plugins/web-search",        from:oh-my-zsh

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

## Autocompletion/suggestion stuff
zplug "djui/alias-tips"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"

## zsh-syntax-highlighting must be loaded after executing compinit command
## and sourcing other plugins
#zplug "zsh-users/zsh-syntax-highlighting", defer:2
#zplug "zsh-users/zsh-history-substring-search", defer:3

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
=======
if [[ -s ${ZSH_INIT} ]]; then
    source ${ZSH_INIT}
else
    echo "Could not find the zsh init script ${ZSH_INIT}"
>>>>>>> 27399756bb07e9f320304b1bcc833a0d7f35cf4e
fi

# Source the bash config
#
# If we are starting-up an iterm session, then the config
# will be in the home directory.  If we are not, then we
# may be starting from an out-of-home position.
if [ -z $ITERM_PROFILE ]; then
    if [[ -s $PWD/.bashrc ]]; then
        source $PWD/.bashrc
    else
        source ~/.bashrc
    fi
else if
    source ~/.bashrc
fi

# https://gist.github.com/ctechols/ca1035271ad134841284
# https://carlosbecker.com/posts/speeding-up-zsh
autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
    compinit;
else
    compinit -C;
fi

# Report profiling (if activated)
if [ $ZSH_PROFILE_MODE -eq 1 ]; then
    zprof
fi
