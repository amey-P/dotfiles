return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    -- {
    --     "neovim/nvim-lspconfig",
    --     dependencies = {
    --         'saghen/blink.cmp',
    --         {
    --             "folke/lazydev.nvim",
    --             ft = "lua",
    --             opts = {
    --                 library = {
    --                     { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    --                 },
    --             },
    --         },
    --     },
    --     opts = {
    --         servers = {
    --             lua_ls = {},
    --             rust_analyzer = {},
    --             ruff = { init_options = { settings = { } } }
    --         },
    --     },
    --     config = function(_, opts)
    --         local lspconfig = require('lspconfig')
    --
    --         -- Setup diagnostic keymaps
    --         vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
    --         vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
    --         vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic in floating window' })
    --         vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Add diagnostics to location list' })
    --         vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "LSP Format Buffer" })
    --         vim.keymap.set("v", "<leader>cf", vim.lsp.buf.format, { desc = "LSP Format Selection" })
    --         vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
    --         vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    --         vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Go to Definition" })
    --         vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Go to Definition" })
    --         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Format Buffer" })
    --
    --         for server, config in pairs(opts.servers) do
    --             config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
    --             lspconfig[server].setup(config)
    --         end
    --     end,
    -- },
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
        end
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function(_, opts)
            vim.keymap.set("n", "<F5>", function() require 'dap'.continue() end)
            vim.keymap.set("n", "<F10>", function() require 'dap'.step_over() end)
            vim.keymap.set("n", "<F11>", function() require 'dap'.step_into() end)
            vim.keymap.set("n", "<F12>", function() require 'dap'.step_out() end)
            vim.keymap.set("n", "<Leader>b", function() require 'dap'.toggle_breakpoint() end)
            vim.keymap.set("n", "<Leader>B",
                function() require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
            vim.keymap.set("n", "<Leader>lp",
                function() require 'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
            vim.keymap.set("n", "<Leader>dr", function() require 'dap'.repl.open() end)
            vim.keymap.set("n", "<Leader>dl", function() require 'dap'.run_last() end)
            vim.keymap.set("n", '<leader>dk', function() require('dap').continue() end)
            vim.keymap.set("n", '<leader>dl', function() require('dap').run_last() end)
            vim.keymap.set("n", '<leader>b', function() require('dap').toggle_breakpoint() end)
        end,
    },
    {
        'nvim-flutter/flutter-tools.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
        config = true,
        keys = {
            {
                "<leader>flt",
                "<cmd>FlutterLogToggle<cr>",
                desc = "Flutter Log Toggle",
            },
            {
                "<leader>fls",
                "<cmd>FlutterRun<cr>",
                desc = "Flutter Run",
            },
            {
                "<leader>flr",
                "<cmd>FlutterRestart<cr>",
                desc = "Flutter Restart",
            },
        }
    }
}
