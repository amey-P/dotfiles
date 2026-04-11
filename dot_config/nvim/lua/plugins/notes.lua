return {
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
        },
        keys = {
            { "[t",        mode = {"n"}, function() require("todo-comments").jump_prev() end, { desc = "Previous TODO Commen" } },
            { "]t",        mode = {"n"}, function() require("todo-comments").jump_next() end, { desc = "Next TODO Comment" } },
            { "<Leader>ft",mode = {"n", "v"}, ":TodoTelescope<CR>",                                { desc = "TODO Telescope Search" } }
        },
    }
}
