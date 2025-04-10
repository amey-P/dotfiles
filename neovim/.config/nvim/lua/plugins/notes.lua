local config = require("config.globals").config

return {
    {
      "epwalsh/obsidian.nvim",
      version = "*",  -- recommended, use latest release instead of latest commit
      lazy = true,
      ft = "markdown",
      -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
      -- event = {
      --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      --   -- refer to `:h file-pattern` for more examples
      --   "BufReadPre path/to/my-vault/*.md",
      --   "BufNewFile path/to/my-vault/*.md",
      -- },
      dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",

        -- see below for full list of optional dependencies 👇
      },
      opts = {
        workspaces = {
          {
            name = "personal",
            path = "~/vaults/personal",
          },
          {
            name = "work",
            path = "~/vaults/work",
          },
        },

        -- see below for full list of options 👇
      },
    }
    -- {
    --     "nvim-neorg/neorg",
    --     dependencies = {
    --         { "nvim-lua/plenary.nvim" },
    --         { "nvim-neorg/neorg-telescope" },
    --     },
    --     lazy = false,
    --     version = "*",
    --     config = true,
    --     opts = {
    --         load = {
    --             ["core.integrations.treesitter"] = {
    --                 config = {
    --                     configure_parsers = true,
    --                     install_parsers = true
    --                 }
    --             },
    --             ["core.defaults"] = {},
    --             ["core.ui.calendar"] = {},
    --             ["core.integrations.telescope"] = {},
    --             ["core.concealer"] = {
    --                 config = {
    --                     folds = false,
    --                 }
    --             },
    --             ["core.dirman"] = {
    --                 config = config,
    --             },
    --             ["core.journal"] = {
    --                 config = {
    --                     journal_folder = "journal",
    --                     strategy = "flat"
    --                 }
    --             },
    --             ["core.summary"] = {},
    --             ["core.qol.todo_items"] = {
    --                 config = {
    --                     create_todo_parents = true
    --                 }
    --             },
    --             ["core.export"] = {},
    --             ["core.export.markdown"] = {
    --                 config = {
    --                     extensions = "all"
    --                 }
    --             }
    --         }
    --     },
    --     keys = {
    --         {"<leader>nn", "<cmd>Neorg index<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>r", "<cmd>Neorg return<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>t", "<cmd>Neorg journal today<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>y", "<cmd>Neorg journal yesterday<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>tu", "<cmd>Neorg journal toc update<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>i", "<cmd>Neorg journal toc open<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>e", "<cmd>Neorg keybind all core.looking-glass.magnify-code-block<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>mi", "<cmd>Neorg inject-metadata<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>mu", "<cmd>Neorg update-metadata<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>is", "<cmd>Neorg generate-workspace-summary<CR>", mode = { "n" }, desc="Open Index File"},
    --
    --         {"<localleader>f", "<cmd>Telescope neorg find_norg_files<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>f", "<cmd>Telescope neorg search_headings<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>lf", "<cmd>Telescope neorg insert_file_link<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>lh", "<cmd>Telescope neorg search_headings<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>bf", "<cmd>Telescope neorg find_backlinks<CR>", mode = { "n" }, desc="Open Index File"},
    --         {"<localleader>bh", "<cmd>Telescope neorg find_header_backlinks<CR>", mode = { "n" }, desc="Open Index File"},
    --     },
    -- },
}
