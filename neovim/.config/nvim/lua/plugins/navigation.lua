return {
    ------------------------------------------------------------------------------------------------------------------
    -------------------------------------------- File Managers -------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
        },
        keys = {
            { "<F2>", "<cmd>Neotree toggle<CR>", mode={"n", "i", "v"}, desc="Toggle NeoTree Side-Pane" },
        },
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
        keys = {
            -- { "<F3>", require('oil').toggle_float, mode={"n", "i", "v"}, desc="Toggle Oil FLoating Window" },
        },
    },

    ------------------------------------------------------------------------------------------------------------------
    -------------------------------------------- Telescope related ---------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        lazy=false,
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", mode={"n", "v"}, desc="Telescope Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", mode={"n", "v"}, desc="Telescope Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", mode={"n", "v"}, desc="Telescope Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", mode={"n", "v"}, desc="Telescope Help Tags" },
            { "<Leader>gc", "<cmd>Telescope git_commits<cr>", mode={"n", "v"}, desc="List Git Commits" },
            { "<Leader>gf", "<cmd>Telescope git_files<cr>", mode={"n", "v"}, desc="List Git Files" },
            { "<Leader>gs", "<cmd>Telescope git_stash<cr>", mode={"n", "v"}, desc="List Git Stash" },
            { "<Leader>gg", "<cmd>Telescope git_status<cr>", mode={"n", "v"}, desc="Git Status" },
        },
    },
    {
        'nvim-telescope/telescope-symbols.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        lazy=false,
        keys = {
            { "<c-e>", "<cmd>Telescope symbols<cr>", mode={"i", "n", "v"}, desc="Telescope Symbols" },
        },
    },
    {
        'ahmedkhalf/project.nvim',
        lazy=false,
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            require('telescope').load_extension('projects')
        end,
        keys = {
            { "<leader>fp", "<cmd>Telescope projects<cr>", mode={"n", "v"}, desc="Telescope Projects" },
        },
    },
    ------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------ Miscellaneous ---------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------
    {
          "hedyhli/outline.nvim",
          lazy = false,
          keys = {
              { "<leader>o", "<cmd>Outline<cr>", mode={"n", "v"}, desc="Outline" },
          },
          config = function ()
              require("outline").setup()
          end,
    }
}
