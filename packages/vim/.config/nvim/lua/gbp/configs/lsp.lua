local debug = false -- set to 'true' if you want debuggin information turned on

------------------------------
-- Set personal preferences --
------------------------------
-- Python will be handled by Ruff, configured below
local servers = {
  "lua_ls",   --> lua
  "clangd",   --> C, C++, Objective-C
  "tsserver", --> typescript, javascript
  "bashls",   --> bash, zsh
}

local mason_icons= {
  package_installed = "",
  package_pending = "",
  package_uninstalled = "",
}

local sign_icons = {
  error = '',
  warn = '',
  hint = '',
  info = ''
}

vim.diagnostic.config({
    underline = true,
    -- virtual_text = { spacing = 4 },
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
})

--------------------------------------------------------------------
-- Most of the rest of this will generally not need to be touched --
--------------------------------------------------------------------
local on_attach = function(client, bufnr)
    require("gbp.mappings")
    set_mappings_lsp(client)
    vim.g.lsp_diagnostic_sign_priority = 100
end

-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = false,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
  setup_servers_on_start = true,
})
lsp.set_sign_icons(sign_icons)
lsp.on_attach(on_attach)

-- Configure Ruff's LSP
require('lspconfig').ruff.setup{}

-- Configure Mason
require("mason").setup({ui = { icons = mason_icons } })

require('mason-lspconfig').setup({
  ensure_installed = servers,
  handlers = {
    lsp.default_setup,
    lua_ls = function()
      local lua_opts = lsp.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  },
})

if debug then
   vim.lsp.set_log_level("debug")
end

lsp.setup() -- this should be the last lsp-zero function called
