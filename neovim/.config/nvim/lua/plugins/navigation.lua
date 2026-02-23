return {
    ------------------------------------------------------------------------------------------------------------------
    -------------------------------------------- File Managers -------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------
    -- {
    --     "nvim-neo-tree/neo-tree.nvim",
    --     branch = "v3.x",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-tree/nvim-web-devicons",
    --         "MunifTanjim/nui.nvim",
    --         "3rd/image.nvim",
    --     },
    --     keys = {
    --         { "<F2>", "<cmd>Neotree toggle<CR>", mode={"n", "i", "v"}, desc="Toggle NeoTree Side-Pane" },
    --     },
    -- },
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        dependencies = {
            "folke/snacks.nvim"
        },
        keys = {
            {
                "<F2>",
                mode = { "n", "v" },
                "<cmd>Yazi<cr>",
                desc = "Open yazi at the current file",
            },
            {
                -- Open in the current working directory
                "<leader>fex",
                "<cmd>Yazi cwd<cr>",
                desc = "Open the file manager in nvim's working directory",
            },
            {
                "<leader>fet",
                "<cmd>Yazi toggle<cr>",
                desc = "Resume the last yazi session",
            },
        },
        opts = {
            -- if you want to open yazi instead of netrw, see below for more info
            open_for_directories = false,
            keymaps = {
                show_help = "<f1>",
            },
        },
        init = function()
            vim.g.loaded_netrwPlugin = 1
        end,
    },
    {
        'stevearc/oil.nvim',
        opts = {
            columns = {
                "type",
                "icon",
                "permissions",
                "size",
                "birthtime",
                "mtime",
            },
            view_options = {
                float = {
                    padding = 1000,
                },
            },
        },
        dependencies = {
            { "echasnovski/mini.icons", opts = {} },
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            vim.keymap.set({ "i", "n", "v" }, "<F3>", require("oil").toggle_float,
                { silent = true, noremap = true, desc = "Toggle Oil Floating Window" })
        end
    },

    ------------------------------------------------------------------------------------------------------------------
    -------------------------------------------- Telescope related ---------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function()
            require('telescope').load_extension('fzf')
            -- Core Bindings
            vim.keymap.set({ "n", "v" }, "<leader>ff", ":Telescope find_files<cr>",
                { silent = true, noremap = true, desc = "Telescope Find Files" })
            vim.keymap.set({ "n", "v" }, "<leader>fg", ":Telescope live_grep<cr>",
                { silent = true, noremap = true, desc = "Telescope Live Grep" })
            vim.keymap.set({ "n", "v" }, "<leader>fb", ":Telescope buffers<cr>",
                { silent = true, noremap = true, desc = "Telescope Buffers" })
            vim.keymap.set({ "n", "v" }, "<Leader>km", ":Telescope keymaps<cr>",
                { silent = true, noremap = true, desc = "Show Keymaps" })
            vim.keymap.set({ "n", "v" }, "<leader>fh", ":Telescope help_tags<cr>",
                { silent = true, noremap = true, desc = "Telescope Help Tags" })

            -- Git Bindings
            vim.keymap.set({ "n", "v" }, "<Leader>gc", ":Telescope git_commits<cr>",
                { silent = true, noremap = true, desc = "List Git Commits" })
            vim.keymap.set({ "n", "v" }, "<Leader>gf", ":Telescope git_files<cr>",
                { silent = true, noremap = true, desc = "List Git Files" })
            vim.keymap.set({ "n", "v" }, "<Leader>gs", ":Telescope git_stash<cr>",
                { silent = true, noremap = true, desc = "List Git Stash" })
            vim.keymap.set({ "n", "v" }, "<Leader>gg", ":Telescope git_status<cr>",
                { silent = true, noremap = true, desc = "Git Status" })

            -- Diagnostics
            vim.keymap.set({ "n", "v" }, "<Leader>ce",
                ':lua require"telescope.builtin"diagnostics{ severity = "error" }<cr>',
                { silent = true, noremap = true, desc = "Errors in Current Project" })
            vim.keymap.set({ "n", "v" }, "<Leader>cd", ':Telescope diagnostics<cr>',
                { silent = true, noremap = true, desc = "List Git Commits" })
        end,
    },
    {
        'nvim-telescope/telescope-symbols.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        lazy = false,
        keys = {
            { "<c-e>", "<cmd>Telescope symbols<cr>", mode = { "i", "n", "v" }, desc = "Telescope Symbols" },
        },
    },
    -- {
    --     'ahmedkhalf/project.nvim',
    --     lazy = false,
    --     dependencies = {
    --         'nvim-telescope/telescope.nvim',
    --     },
    --     config = function()
    --         require('telescope').load_extension('projects')
    --     end,
    --     keys = {
    --         { "<leader>fp", "<cmd>Telescope projects<cr>", mode = { "n", "v" }, desc = "Telescope Projects" },
    --     },
    -- },
    ------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------ Miscellaneous ---------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------
    -- {
    --     "ggandor/leap.nvim",
    --     config = function()
    --         require("leap").set_default_mappings()
    --     end
    -- },
    -- {
    --     "hedyhli/outline.nvim",
    --     lazy = false,
    --     keys = {
    --         { "<leader>o", "<cmd>Outline<cr>", mode = { "n", "v" }, desc = "Outline" },
    --     },
    --     config = function()
    --         require("outline").setup()
    --     end,
    -- }
}
