#!/usr/bin/env zsh
# vim:syntax=zsh
# vim:filetype=zsh


# load the theme system
autoload -U promptinit && promptinit

# -----------------------------------------------
# for dynamic named directories
setopt prompt_subst
setopt auto_name_dirs

# -----------------------------------------------
# PROMPT COLORS

reset_color=%{$'\e[00m'%}
export CLICOLOR=1

# Color table from: http://www.understudy.net/custom.html
fg_black=%{$'\e[0;30m'%}
fg_red=%{$'\e[0;31m'%}
fg_green=%{$'\e[0;32m'%}
fg_brown=%{$'\e[0;33m'%}
fg_blue=%{$'\e[0;34m'%}
fg_purple=%{$'\e[0;35m'%}
fg_cyan=%{$'\e[0;36m'%}
fg_lgray=%{$'\e[0;37m'%}
fg_dgray=%{$'\e[1;30m'%}
fg_lred=%{$'\e[1;31m'%}
fg_lgreen=%{$'\e[1;32m'%}
fg_yellow=%{$'\e[1;33m'%}
fg_lblue=%{$'\e[1;34m'%}
fg_pink=%{$'\e[1;35m'%}
fg_lcyan=%{$'\e[1;36m'%}
fg_white=%{$'\e[1;37m'%}

#Text Background Colors
bg_red=%{$'\e[0;41m'%}
bg_green=%{$'\e[0;42m'%}
bg_brown=%{$'\e[0;43m'%}
bg_blue=%{$'\e[0;44m'%}
bg_purple=%{$'\e[0;45m'%}
bg_cyan=%{$'\e[0;46m'%}
bg_gray=%{$'\e[0;47m'%}

#Attributes
at_normal=%{$'\e[0m'%}
at_bold=%{$'\e[1m'%}
at_italics=%{$'\e[3m'%}
at_underl=%{$'\e[4m'%}
at_blink=%{$'\e[5m'%}
at_outline=%{$'\e[6m'%}
at_reverse=%{$'\e[7m'%}
at_nondisp=%{$'\e[8m'%}
at_strike=%{$'\e[9m'%}
at_boldoff=%{$'\e[22m'%}
at_italicsoff=%{$'\e[23m'%}
at_underloff=%{$'\e[24m'%}
at_blinkoff=%{$'\e[25m'%}
at_reverseoff=%{$'\e[27m'%}
at_strikeoff=%{$'\e[29m'%}

# precmd is called just before the prompt is printed
precmd () {
  # Draw an underlined blank line
  print -Pn "${fg_cyan}%U${(r:$COLUMNS:: :)}%u%{$reset_color%}"
}

# preexec is called just before any command line is executed
preexec () {
  # Draw a blank line
  print 
}

#export PROMPT="╰ "
export PROMPT="╰> "

# Set colours
zstyle :prompt:pure:git:branch color yellow
zstyle :prompt:pure:virtualenv color green
zstyle :prompt:pure:execution_time color red

# or use pre_cmd, see man zshcontrib
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
