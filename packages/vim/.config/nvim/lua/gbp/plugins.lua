-- Ensure that Packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

-- Automatically run ':PackerCompile' whenever this file is edited
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Source plugins
return require('packer').startup({function(use)

    -- Packer can manage itself as an optional plugin
    use { 'wbthomason/packer.nvim', opt = true}

    -- My plugins here

    -- Colour scheme
    use { 'tomasr/molokai', config = [[require('gbp.configs.molokai')]] }

    -- Telescope
    use { 'nvim-telescope/telescope.nvim',
       tag = '0.1.0',
       requires = {{'nvim-lua/plenary.nvim'}},
       config = [[require('gbp.configs.telescope')]]
    }

    -- LSP
    use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v1.x',
      requires = {

        -- LSP Support
        {'neovim/nvim-lspconfig'},             -- Required
        {'williamboman/mason.nvim'},           -- Optional
        {'williamboman/mason-lspconfig.nvim'}, -- Optional

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},         -- Required
        {'hrsh7th/cmp-nvim-lsp'},     -- Required
        {'hrsh7th/cmp-buffer'},       -- Optional
        {'hrsh7th/cmp-path'},         -- Optional
        {'saadparwaiz1/cmp_luasnip'}, -- Optional
        {'hrsh7th/cmp-nvim-lua'},     -- Optional

        -- Snippets
        {'L3MON4D3/LuaSnip'},             -- Required
        {'rafamadriz/friendly-snippets'}, -- Optional
      },
      config = [[require('gbp.configs.lsp')]]
    }

  -- use { 'tpope/vim-sensible', config = [[require('config.XXX']] }
  -- use { 'vim-airline/vim-airline', config = [[require('config.XXX']] }
  -- use { 'vim-airline/vim-airline-themes', config = [[require('config.XXX']] }
  -- use { 'editorconfig/editorconfig-vim', config = [[require('config.XXX']] }
  -- use { 'tmux-plugins/vim-tmux-focus-events', config = [[require('config.XXX']] }
  -- use { 'tpope/vim-rsi', config = [[require('config.XXX']] }
  -- use { 'tpope/vim-surround', config = [[require('config.XXX']] }
  -- -- use { 'justinmk/vim-sneak', config = [[require('config.XXX']] }
  -- use { 'jiangmiao/auto-pairs', config = [[require('config.XXX']] }
  -- use { 'scrooloose/nerdcommenter', config = [[require('config.XXX']] }
  -- use { 'SirVer/ultisnips' | Plug 'honza/vim-snippets', config = [[require('config.XXX']] }
  -- use { 'chrisbra/vim-diff-enhanced', config = [[require('config.XXX']] }
  -- use { 'tpope/vim-vinegar', config = [[require('config.XXX']] }
  -- use { 'majutsushi/tagbar', config = [[require('config.XXX']] }
  -- use { 'airblade/vim-gitgutter', config = [[require('config.XXX']] }
  -- use { 'rhysd/git-messenger.vim', config = [[require('config.XXX']] }
  -- use { 'preservim/nerdtree', config = [[require('config.XXX']] }
  -- use { 'Xuyuanp/nerdtree-git-plugin', config = [[require('config.XXX']] }
  -- use { 'ryanoasis/vim-devicons', config = [[require('config.XXX']] }
  -- use { 'PhilRunninger/nerdtree-buffer-ops', config = [[require('config.XXX']] }
  -- use { 'mileszs/ack.vim', config = [[require('config.XXX']] }
  -- use { 'w0rp/ale', config = [[require('config.XXX']] }
  -- -- use { 'reedes/vim-wordy', { 'for': ['markdown', 'tex', 'latex'] }, config = [[require('config.XXX']] }
  -- -- use { 'davidbeckingsale/writegood.vim', { 'for': ['tex', 'markdown', 'latex'] }, config = [[require('config.XXX']] }
  -- use { 'junegunn/goyo.vim', { 'on': 'Goyo' }, config = [[require('config.XXX']] }
  -- use { 'sheerun/vim-polyglot', config = [[require('config.XXX']] }
  -- use { 'Glench/Vim-Jinja2-Syntax', { 'for': 'html' }, config = [[require('config.XXX']] }
  -- use { 'vim-python/python-syntax', { 'for': 'python' }, config = [[require('config.XXX']] }
  -- use { 'Vimjas/vim-python-pep8-indent', { 'for': 'python'}, config = [[require('config.XXX']] }
  -- use { 'davidhalter/jedi-vim', { 'for': 'python' }, config = [[require('config.XXX']] }
  -- use { 'tmhedberg/SimpylFold', { 'for': 'python' }, config = [[require('config.XXX']] }
  -- use { 'yuttie/comfortable-motion.vim', config = [[require('config.XXX']] }
  -- use { 'tpope/vim-obsession', config = [[require('config.XXX']] }
  -- use { 'tpope/vim-sleuth', config = [[require('config.XXX']] }

  -- Automatically set up configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}})
