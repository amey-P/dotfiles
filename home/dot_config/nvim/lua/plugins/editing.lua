return {
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    {
        'numToStr/Comment.nvim',
        opts = {}
    },
    {
        'mbbill/undotree',
        keys = {
            { "<F4>", vim.cmd.UndotreeToggle, mode={"n", "v", "i"}, desc="UndoTree" },
        }
    },
    {
        'dhruvasagar/vim-table-mode',
        keys = {
            { "<leader>tm", "<cmd>TableModeToggle<cr>", mode={"n", "v"}, desc="Table Mode Toggle" },
        },
    },
}
