return {
    {
        'saghen/blink.cmp',
        version = 'v0.11.0',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'super-tab' },
            appearance = {
                nerd_font_variant = 'mono'
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                cmdline = {},
            },
        },
        signature = { enabled = true },
    }
}
