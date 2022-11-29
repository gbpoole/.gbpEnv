-- Vim config file for gbp

-- Reduce boilerplate with these: {{{
local GBP_HOME = os.getenv("GBP_HOME")
local vo = vim.opt -- option objects
local go = vim.o   -- global options
local wo = vim.wo  -- window options
local bo = vim.bo  -- buffer options
-- }}}

-- Avoid modeline vulnerability: {{{
go.nomodeline = false

-- Set-up secure modeline as per: https://blog.firosolutions.com/exploits/vimsploit/
go.secure_modelines_verbose = 0
go.secure_modelines_modelines = 15
-- }}}

-- Change leader mapping: {{{
go.mapleader = ' '
-- }}}

-- OPTIONS {{{

go.fileencoding = "utf-8"     -- the encoding written to a file
go.title        = true        -- Show filename in titlebar of window
-- go.foldmethod = 'marker'   -- Enable marker folding for vimrc 
                              -- (secure modeline covers other cases)
go.nomore = true              -- Don't page long listings
-- go.cpoptions-=a         -- Don't set # after a :read
go.autowrite    = true     -- Save buffer automatically when changing files
go.swapfile     = false
go.autoread     = true     -- Always reload buffer when external changes detected
go.backspace    = "indent,eol,start"  -- BS past autoindents, line boundaries,
                                      --     and even the start of insertion
go.fileformats  = "unix,mac,dos"      -- Handle Mac and DOS line-endings
                                      -- but prefer Unix endings
--Wildmenu:
--   First tab: longest match, list in the statusbar.
--   Following tabs: cycle through matches
go.wildmenu = true                  -- show list instead of just completing
go.wildmode = "list:longest,full"   -- Show list of completions
                                    --   and complete as much as possible,
                                    --   then iterate full completions
-- go.wildmenu wildmode=longest:full,full

go.showmode = false                 -- Suppress mode change messages
go.updatetime = 2000                -- idleness is 2 sec
go.scrolloff = 20                   -- Scroll when X lines from top/bottom
go.visualbell = false               -- Turn off visual beep
go.laststatus = 2                   -- Always display a status line
go.cmdheight = 1                    -- Command line height
go.hlsearch = true                  -- Highlight searches
go.hidden = true                    -- Don't unload a buffer when abandoning it
go.clipboard = "unnamedplus"        -- To work in tmux
go.spelllang = "en_au"              -- Australian spelling
go.secure = true                    -- Secure mode for reading vimrc, exrc files etc. in current dir
go.exrc = true                      -- Allow the use of folder dependent settings
go.autoindent = true                -- Autoindent
go.smartindent = true               -- Note that this might mess with python comment indents.
go.vim_indent_cont = 0              -- No magic shifts on Vim line continuations
go.wrap = true                      -- Wrap lines
go.linebreak = true                 -- Wrap at breaks
go.textwidth = 0 
go.wrapmargin = 2
go.display = "lastline"
vo.formatoptions:append("l")        -- Dont mess with the wrapping of existing lines

-- Tabs
go.smarttab = true
go.expandtab = true                 -- convert tabs to spaces
go.shiftwidth = 4                   -- the number of spaces inserted for each indentation
go.tabstop = 4                      -- the number of space inserted for a tab

vo.nrformats:remove('octal')        -- make sure that numbers starting with a 0 are not
                                    -- treated as octals when using CRTL-A or X to increment
                                    -- or decrement

go.incsearch = true                 -- Highlight matches as you type
go.showmatch = true                 -- Show matching paren
-- go.infercase = true              -- Adjust completions to match case
go.gdefault = true                  -- g flag on sed subs automatically

go.directory = GBP_HOME .. "/.cache/vim/"
go.backupdir = GBP_HOME .. "/.cache/vim/bkp"

-- List mode stuff
go.list = true -- Start in list mode by default
vim.opt.listchars = { -- Set hidden characters
    tab = '▸ ',
    eol = '↵',
    trail = '·'
}

go.number = true             -- Show line numbers
go.relativenumber = true     -- Show relative line numbers
go.cursorline = true         -- highlight current line
go.cursorlineopt = "number"  -- highlight current line
go.mouse = "a"               -- enable mouse for all modes settings.  Also avoids copying line numbers:
                             -- https://stackoverflow.com/questions/5728259/how-to-clear-the-line-number-in-vim-when-copying

-- Persistant undo
go.undofile = true   -- Turn-on persistent undo
go.undolevels = 1000 -- Save a lot of back-history
go.undodir = GBP_HOME .. "/.cache/vim/undo/"  -- Save all undo files in a single location 
                                              --    (less messy, more risky)...

-- Disabled options
--go.titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
--go.complete-=t                             -- I don't use tags, so no need to search for them
--go.updatecount=50                          -- Save buffer every X chars typed
--go.timeout timeoutlen=300 ttimeoutlen=300  -- Keycodes and maps timeout in 3/10 sec...
--go.shellcmdflag=-ic                        -- Use an interactive shell to allow use of command line aliases
--go.c_syntax_for_h = 1                    -- Use c-syntax
--
--go.wildignore+=*.o,*.obj,*.pyc,
--            \*.aux,*.blg,*.fls,*.blg,*.fdb_latexmk,*.latexmain,.DS_Store,
--            \Session.vim,Project.vim,tags,.tags,.sconsign.dblite,.ccls-cache
--
-- Set suffixes that are ignored with multiple match
--go.suffixes=.bak,~,.o,.info,.swp,.obj

go.pumblend = 20        -- opacity for popupmenu
go.inccommand = "split" -- Live substitution

-- Better display for messages
go.cmdheight = 2

-- Long update times (default is 4000ms) leads to noticable delays and a bad
-- experience for diagnostic messages
go.updatetime = 300

-- don't give |ins-completion-menu| messages.
-- go.shortmess+=c

-- always show signcolumns
go.signcolumn = "yes"

-- Change visual highlighting colour
-- hi Visual cterm=bold ctermbg=Grey ctermfg=NONE


-- Prefer vertical orientation when using :diffsplit 
vo.diffopt:append("vertical")

-- Goto last location in non-empty files
--autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
--                   \|     exe "normal! g`\""
--                   \|  endif

-- Smarter search behaviour {{{
-- Absolute direction for n and N...
-- nnoremap  <silent><expr> n  'Nn'[v:searchforward] . ":call HLNext()\<CR>"
-- nnoremap  <silent><expr> N  'nN'[v:searchforward] . ":call HLNext()\<CR>"

--Delete in normal mode to switch off highlighting till next search and clear messages...
-- Nmap <silent> <BS> [Cancel highlighting]  :call HLNextOff() <BAR> :nohlsearch <CR>

--Double-delete to remove trailing whitespace...
-- function! TrimTrailingWS ()
--     if search('\s\+$', 'cnw')
--         :%s/\s\+$//g
--     endif
-- endfunction
-- Nmap <silent> <BS><BS>  [Remove trailing whitespace] mz:call TrimTrailingWS()<CR>`z

-- }}}

-- Smart wrapping {{{

-- No smartwrapping in any of these files...
--go.SW_IGNORE_FILES = '.vimrc,*.vim,*.pl,*.pm,**/bin/**'

-- go.comments-=s1:/*,mb:*,ex:*/      --Don't recognize C comments
-- go.comments-=:XCOMM                --Don't recognize lmake comments
-- go.comments-=:%                    --Don't recognize PostScript comments
-- go.comments-=:#                    --Don't recognize Perl/shell comments
-- go.comments+=fb:*                  --Star-space is a bullet
-- go.comments+=fb:-                  --Dash-space is a bullets

--[[
c       Auto-wrap comments using 'textwidth', inserting the current comment
        leader automatically.
                                                        fo-r
r       Automatically insert the current comment leader after hitting
        <Enter> in Insert mode.
                                                        fo-o
o       Automatically insert the current comment leader after hitting 'o' or
        'O' in Normal mode.  In case comment is unwanted in a specific place
        use CTRL-U to quickly delete it. i_CTRL-U
--]]
vo.formatoptions:remove('cro')
vo.formatoptions:append('j')          -- Remove comment introducers when joining comment lines
-- go.cinoptions+=#1
-- go.cinkeys-=0#
-- }}}

--And no shift magic on comments...
-- function! ShiftLine() range
--     go.nosmartindent
--     exec "normal! " . v:count . ">>"
--     go.smartindent
--     silent! call repeat#set( "\<Plug>ShiftLine" )
-- endfunction
-- nmap <silent>  >>  <Plug>ShiftLine
-- nnoremap <Plug>ShiftLine :call ShiftLine()<CR>

-- function! InitBackupDir()
--   if exists('*mkdir')
--     if !isdirectory(&directory)
--       call mkdir(&directory)
--     endif
--     if !isdirectory(&backupdir)
--       call mkdir(&backupdir)
--     endif
--     if !isdirectory(&undodir)
--       call mkdir(&undodir)
--     endif
--   endif
--   go.l:missing_dir = 0
--   if !isdirectory(&directory)
--     go.l:missing_dir = 1
--   endif
--   if !isdirectory(&backupdir)
--     go.l:missing_dir = 1
--   endif
--   if !isdirectory(&undodir)
--     go.l:missing_dir = 1
--   endif
--   if l:missing_dir
--     echo 'Warning: Unable to create scratch directories:' &directory ',' &backupdir 'and' &undodir
--     echo 'Try: mkdir -p' &directory
--     echo 'and: mkdir -p' &backupdir
--     echo 'and: mkdir -p' &undodir
--     go.directory=.
--     go.backupdir=.
--     go.undodir=.
--   endif
-- endfunction
-- call InitBackupDir()

-- Assorted Leader Commands {{{
--  nnoremap <leader><esc> :bd<CR>
--  nnoremap <silent> <ctrl>Y 0vg_y -- Make sure yank-line does not include the <CR>
-- }}}
