-- Vim config file for gbp

-- Reduce boilerplate with these: {{{
local GBP_HOME = os.getenv("GBP_HOME")
local vo = vim.opt -- option objects
local oo = vim.o   -- global options
local go = vim.g   -- global options
local wo = vim.wo  -- window options
local bo = vim.bo  -- buffer options
-- }}}

-- Avoid modeline vulnerability: {{{
oo.nomodeline = false

-- Set-up secure modeline as per: https://blog.firosolutions.com/exploits/vimsploit/
oo.secure_modelines_verbose = 0
oo.secure_modelines_modelines = 15
-- }}}

-- Change leader mapping: {{{
go.mapleader = ' '
go.maplocalleader = '\\'
-- }}}

-- OPTIONS {{{

oo.fileencoding = "utf-8"     -- the encoding written to a file
oo.title        = true        -- Show filename in titlebar of window
-- oo.foldmethod = 'marker'   -- Enable marker folding for vimrc 
                              -- (secure modeline covers other cases)
oo.nomore = true              -- Don't page long listings
-- oo.cpoptions-=a         -- Don't set # after a :read
oo.autowrite    = true     -- Save buffer automatically when changing files
oo.swapfile     = false
oo.autoread     = true     -- Always reload buffer when external changes detected
oo.backspace    = "indent,eol,start"  -- BS past autoindents, line boundaries,
                                      --     and even the start of insertion
oo.fileformats  = "unix,mac,dos"      -- Handle Mac and DOS line-endings
                                      -- but prefer Unix endings
--Wildmenu:
--   First tab: longest match, list in the statusbar.
--   Following tabs: cycle through matches
oo.wildmenu = true                  -- show list instead of just completing
oo.wildmode = "list:longest,full"   -- Show list of completions
                                    --   and complete as much as possible,
                                    --   then iterate full completions
-- oo.wildmenu wildmode=longest:full,full

oo.showmode = false                 -- Suppress mode change messages
oo.updatetime = 2000                -- idleness is 2 sec
oo.scrolloff = 20                   -- Scroll when X lines from top/bottom
oo.visualbell = false               -- Turn off visual beep
oo.laststatus = 2                   -- Always display a status line
oo.cmdheight = 1                    -- Command line height
oo.hlsearch = true                  -- Highlight searches
oo.hidden = true                    -- Don't unload a buffer when abandoning it
oo.clipboard = "unnamedplus"        -- To work in tmux
oo.spelllang = "en_au"              -- Australian spelling
oo.secure = true                    -- Secure mode for reading vimrc, exrc files etc. in current dir
oo.exrc = true                      -- Allow the use of folder dependent settings
oo.autoindent = true                -- Autoindent
oo.smartindent = true               -- Note that this might mess with python comment indents.
oo.vim_indent_cont = 0              -- No magic shifts on Vim line continuations
oo.wrap = true                      -- Wrap lines
oo.linebreak = true                 -- Wrap at breaks
oo.textwidth = 0 
oo.wrapmargin = 2
oo.display = "lastline"
vo.formatoptions:append("l")        -- Dont mess with the wrapping of existing lines

-- Tabs
oo.smarttab = true
oo.expandtab = true                 -- convert tabs to spaces
oo.shiftwidth = 4                   -- the number of spaces inserted for each indentation
oo.tabstop = 4                      -- the number of space inserted for a tab

vo.nrformats:remove('octal')        -- make sure that numbers starting with a 0 are not
                                    -- treated as octals when using CRTL-A or X to increment
                                    -- or decrement

oo.incsearch = true                 -- Highlight matches as you type
oo.showmatch = true                 -- Show matching paren
-- oo.infercase = true              -- Adjust completions to match case
oo.gdefault = true                  -- g flag on sed subs automatically

oo.directory = GBP_HOME .. "/.cache/vim/"
oo.backupdir = GBP_HOME .. "/.cache/vim/bkp"

-- List mode stuff
oo.list = true -- Start in list mode by default
vim.opt.listchars = { -- Set hidden characters
    tab = '▸ ',
    eol = '↵',
    trail = '·'
}

oo.number = true             -- Show line numbers
oo.relativenumber = true     -- Show relative line numbers
oo.cursorline = true         -- highlight current line
oo.cursorlineopt = "number"  -- highlight current line
oo.mouse = "a"               -- enable mouse for all modes settings.  Also avoids copying line numbers:
                             -- https://stackoverflow.com/questions/5728259/how-to-clear-the-line-number-in-vim-when-copying

-- Persistant undo
oo.undofile = true   -- Turn-on persistent undo
oo.undolevels = 1000 -- Save a lot of back-history
oo.undodir = GBP_HOME .. "/.cache/vim/undo/"  -- Save all undo files in a single location 
                                              --    (less messy, more risky)...

-- Disabled options
--oo.titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
--oo.complete-=t                             -- I don't use tags, so no need to search for them
--oo.updatecount=50                          -- Save buffer every X chars typed
--oo.timeout timeoutlen=300 ttimeoutlen=300  -- Keycodes and maps timeout in 3/10 sec...
--oo.shellcmdflag=-ic                        -- Use an interactive shell to allow use of command line aliases
--oo.c_syntax_for_h = 1                    -- Use c-syntax
--
--oo.wildignore+=*.o,*.obj,*.pyc,
--            \*.aux,*.blg,*.fls,*.blg,*.fdb_latexmk,*.latexmain,.DS_Store,
--            \Session.vim,Project.vim,tags,.tags,.sconsign.dblite,.ccls-cache
--
-- Set suffixes that are ignored with multiple match
--oo.suffixes=.bak,~,.o,.info,.swp,.obj

oo.pumblend = 20        -- opacity for popupmenu
oo.inccommand = "split" -- Live substitution

-- Better display for messages
oo.cmdheight = 2

-- Long update times (default is 4000ms) leads to noticable delays and a bad
-- experience for diagnostic messages
oo.updatetime = 300

-- don't give |ins-completion-menu| messages.
-- oo.shortmess+=c

-- always show signcolumns
oo.signcolumn = "yes"

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
--oo.SW_IGNORE_FILES = '.vimrc,*.vim,*.pl,*.pm,**/bin/**'

-- oo.comments-=s1:/*,mb:*,ex:*/      --Don't recognize C comments
-- oo.comments-=:XCOMM                --Don't recognize lmake comments
-- oo.comments-=:%                    --Don't recognize PostScript comments
-- oo.comments-=:#                    --Don't recognize Perl/shell comments
-- oo.comments+=fb:*                  --Star-space is a bullet
-- oo.comments+=fb:-                  --Dash-space is a bullets

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
-- oo.cinoptions+=#1
-- oo.cinkeys-=0#
-- }}}

--And no shift magic on comments...
-- function! ShiftLine() range
--     oo.nosmartindent
--     exec "normal! " . v:count . ">>"
--     oo.smartindent
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
--   oo.l:missing_dir = 0
--   if !isdirectory(&directory)
--     oo.l:missing_dir = 1
--   endif
--   if !isdirectory(&backupdir)
--     oo.l:missing_dir = 1
--   endif
--   if !isdirectory(&undodir)
--     oo.l:missing_dir = 1
--   endif
--   if l:missing_dir
--     echo 'Warning: Unable to create scratch directories:' &directory ',' &backupdir 'and' &undodir
--     echo 'Try: mkdir -p' &directory
--     echo 'and: mkdir -p' &backupdir
--     echo 'and: mkdir -p' &undodir
--     oo.directory=.
--     oo.backupdir=.
--     oo.undodir=.
--   endif
-- endfunction
-- call InitBackupDir()

-- Assorted Leader Commands {{{
--  nnoremap <leader><esc> :bd<CR>
--  nnoremap <silent> <ctrl>Y 0vg_y -- Make sure yank-line does not include the <CR>
-- }}}
