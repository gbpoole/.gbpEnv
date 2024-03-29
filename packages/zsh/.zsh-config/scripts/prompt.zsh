#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh

# Load the theme system
autoload -U promptinit && promptinit

# Activate theme
prompt gbpPrompt

# -----------------------------------------------
# for dynamic named directories
setopt prompt_subst
setopt auto_name_dirs

export CLICOLOR=1

# precmd is called just before the prompt is printed
precmd () {
  # Draw an underlined blank line
  local fg_cyan=%{$'\e[0;36m'%}
  local reset_color=%{$'\e[00m'%}
  print -Pn "${fg_cyan}%U${(r:$COLUMNS:: :)}%u%{$reset_color%}"
}

# preexec is called just before any command line is executed
preexec () {

  # Draw a blank line
  print 
}

# Prompt symbol
export GBPPROMPT_PROMPT_PRESYMBOL="╰"
export GBPPROMPT_PROMPT_SYMBOL=""

# or use pre_cmd, see man zshcontrib
autoload -Uz vcs_info
vcs_info_wrapper() {
  vcs_info
  echo 
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}

# prompt for vi mode
function zle-line-init zle-keymap-select {
    RPROMPT=""
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $(vcs_info_wrapper) $EPS1"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Set colours
# Defaults are as follows:
# zstyle :gbpPrompt:prompt:error         red
# zstyle :gbpPrompt:prompt:success       green
# zstyle :gbpPrompt:execution_time       red
# zstyle :gbpPrompt:git:status           226
# zstyle :gbpPrompt:git:branch           208
# zstyle :gbpPrompt:git:branch:cached    172
# zstyle :gbpPrompt:user                 81
# zstyle :gbpPrompt:user:root            198
# zstyle :gbpPrompt:host                 75
# zstyle :gbpPrompt:conda                35
# zstyle :gbpPrompt:pyenv                47
# zstyle :gbpPrompt:pyenv_global         red
# zstyle :gbpPrompt:prompt:preprompt     218
# zstyle :gbpPrompt:path                 218
