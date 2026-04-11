return {
    {
        'saghen/blink.cmp',
        build = 'cargo build --release',
        -- fuzzy = { implementation = "prefer_rust_with_warning" },
        -- version = 'v0.11.0',
        -- version = '1.*',
        dependencies = { 'L3MON4D3/LuaSnip' },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = { preset = 'luasnip' },
            keymap = { preset = 'super-tab' },
            appearance = {
                nerd_font_variant = 'mono'
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            -- Displays a preview of the selected item on the current line
            signature = { enabled = true },
            completion = {
                ghost_text = {
                    enabled = true,
                    show_with_menu = true,
                },
                menu = {
                    auto_show = true,
                }
            },
            cmdline = {
                enabled = false,    -- Super slow when shell '!' commands are used.
                keymap = { preset = 'inherit' },
                completion = { menu = { auto_show = false } },
            },
        }
    },
}
