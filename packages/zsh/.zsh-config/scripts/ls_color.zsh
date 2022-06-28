#!/usr/bin/env zsh
# vim:syntax=sh
# vim:filetype=sh

# Add colors to ls command
if command -v gdircolors &> /dev/null; then
   eval $( gdircolors -b ${ZSHCONFIG}/scripts/dircolors-custom )
elif command -v dircolors &> /dev/null; then
   eval $( dircolors ${ZSHCONFIG}/scripts/dircolors-custom )
else
   echo Neither 'gdircolors' nor 'dircolors' found.  Could not set colours for 'ls'.
fi
