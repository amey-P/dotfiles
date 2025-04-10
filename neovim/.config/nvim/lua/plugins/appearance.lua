-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
    blue   = '#80a0ff',
    cyan   = '#79dac8',
    black  = '#080808',
    white  = '#c6c6c6',
    red    = '#ff5189',
    violet = '#d183e8',
    grey   = '#303030',
}

local bubbles_theme = {
    normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.white },
    },

    insert = { a = { fg = colors.black, bg = colors.blue } },
    visual = { a = { fg = colors.black, bg = colors.cyan } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.white },
    },
}

return {
    -- Themes
    {
        "folke/tokyonight.nvim",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },
    {
        "shaunsingh/solarized.nvim",
        lazy = true,
    },
    {
        "cocopon/iceberg.vim",
        lazy = true,
    },

    -- Status Bar
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = bubbles_theme,
                component_separators = '',
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
                lualine_b = { 'filename', 'branch' },
                lualine_c = {
                    '%=', --[[ add your center compoentnts here in place of this comment ]]
                },
                lualine_x = {},
                lualine_y = { 'filetype', 'progress' },
                lualine_z = {
                    { 'location', separator = { right = '' }, left_padding = 2 },
                },
            },
            inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
            },
            tabline = {},
            extensions = {},
        },
    },

    -- Language Specific
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
    {
        'cameron-wags/rainbow_csv.nvim',
        config = true,
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim'
        }
    },
    {
        'NvChad/nvim-colorizer.lua',
        config = function(_, opts)
            require("colorizer").setup {
                filetypes = { "*" },
                user_default_options = {
                    RGB = true, -- #RGB hex codes
                    RRGGBB = true, -- #RRGGBB hex codes
                    names = true, -- "Name" codes like Blue or blue
                    RRGGBBAA = true, -- #RRGGBBAA hex codes
                    AARRGGBB = true, -- 0xAARRGGBB hex codes
                    rgb_fn = false, -- CSS rgb() and rgba() functions
                    hsl_fn = false, -- CSS hsl() and hsla() functions
                    css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    -- Available modes for `mode`: foreground, background,  virtualtext
                    mode = "background", -- Set the display mode.
                    -- Available methods are false / true / "normal" / "lsp" / "both"
                    -- True is same as normal
                    tailwind = false,                    -- Enable tailwind colors
                    -- parsers can contain values used in |user_default_options|
                    sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
                    virtualtext = "■",
                    -- update color values even if buffer is not focused
                    -- example use: cmp_menu, cmp_docs
                    always_update = false
                },
                -- all the sub-options of filetypes apply to buftypes
                buftypes = {},
            }
            vim.keymap.set('n', '<leader>clt', ":ColorizerToggle<CR>",
                { desc = 'Toggle Colorizer to highlight HEX code colors' })
        end
    }
}
