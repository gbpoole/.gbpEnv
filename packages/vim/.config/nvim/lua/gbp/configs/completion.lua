----------------------------------
-- Set personal set preferences --
----------------------------------

--------------------------------------------------------------------
-- Most of the rest of this will generally not need to be touched --
--------------------------------------------------------------------

local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()

-- Fetch the key mappings
require("gbp.mappings")
local mappings = set_mappings_completion()

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert(mappings),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
  {
    { name = "buffer" },
  }),
})


