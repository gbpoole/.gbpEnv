require("gbp.mappings")

require('neogen').setup {
    enabled = true,
    snippet_engine = "luasnip",
    languages = {
        lua = {
            template = {
                annotation_convention = "emmylua",
            }
        },
        python = {
            template = {
                annotation_convention = "numpydoc",
            }
        },
    },
}

set_mappings_neogen()
