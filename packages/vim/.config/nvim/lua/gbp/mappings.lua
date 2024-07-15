set_mappings_lsp = function(client)

    local opts = { silent=true }
    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
    vim.keymap.set("n", "gD", "<cmd>Telescope lsp_implementations<CR>", opts)
    vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.keymap.set("n", "1gD", "<cmd>Telescope lsp_type_definitions<CR>", opts)
    vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
    vim.keymap.set("n", "1g/", "<cmd>Telescope lsp_document_symbols<CR>", opts)
    vim.keymap.set("n", "g/", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)
    vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    vim.keymap.set("n", "<localleader>D", "<cmd>Trouble document_diagnostics<cr>", opts)
    vim.keymap.set("n", "<localleader>i", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    vim.keymap.set("n", "<localleader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
    vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

end

set_mappings_telescope = function()

    local builtin = require('telescope.builtin')
    local opts = { silent=true }
    vim.keymap.set('n', 'gf', builtin.find_files, opts)
    vim.keymap.set('n', 'gb', builtin.buffers, opts)
    vim.keymap.set('n', 'gG', builtin.live_grep, opts)
    vim.keymap.set('n', 'gh', builtin.help_tags, opts)

end

set_mappings_completion = function(client)

    local cmp = require("cmp")
    return {['<C-l>'] = cmp.mapping(function() require('luasnip').jump(1) end, {'i','s'}),
            ['<C-h>'] = cmp.mapping(function() require('luasnip').jump(-1) end, {'i','s'}),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
           }
end

set_mappings_neogen = function()

    local opts = { silent=true }
    vim.api.nvim_set_keymap("n", "<Leader>f", ":lua require('neogen').generate()<CR>", opts)

end

-- set_mappings_nerdcommenter = function()
--
--     local opts = { noremap=true, silent=true }
--     vim.api.nvim_set_keymap("n", "<Leader><Leader>", "<plug>NERDCommenterToggle", opts)
--
-- end
