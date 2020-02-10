" CoC Highlighting {{{
highlight CocWarningSign ctermfg=Yellow ctermbg=236
highlight CocErrorSign ctermfg=Red ctermbg=236
highlight CocInfoSign ctermfg=White ctermbg=236
" }}}

" ALE Highlighting {{{
highlight ALEError cterm=underline gui=underline guisp=Red
highlight link ALEWarning WarningMsg
highlight link ALEInfo MoreMsg
highlight ALEWarningSign ctermfg=Yellow ctermbg=236
highlight ALEErrorSign ctermfg=Red ctermbg=236
highlight ALEInfoSign ctermfg=White ctermbg=236
" }}}

" Cursor line number Highlighting {{{
highlight CursorLineNr ctermfg=208 ctermbg=236
" }}}

" Fold Highlighting {{{
highlight Folded ctermfg=67 ctermbg=236
highlight FoldColumn ctermfg=67 ctermbg=236
" }}}

" Needed to make sure that tmux pane highlighting works {{{
highlight Normal ctermbg=None
highlight NonText ctermbg=None
" }}}
