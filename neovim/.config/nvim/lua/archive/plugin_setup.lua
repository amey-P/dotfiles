-- Setups
require('gitsigns').setup()
require("nvim-tree").setup {
    update_focused_file = {
        enable = true,
        update_root = true,

    },
}
require('Comment').setup()
require("project_nvim").setup()
require("telescope").load_extension("projects")
-- require("telescope").load_extension("flutter")
-- require("leap").create_default_mappings()
require("symbols-outline").setup()

-- require("flutter-tools").setup()
-- local null_ls = require("null-ls")
-- null_ls.setup({
--     sources = {
--         null_ls.builtins.formatting.black.with({
--             extra_args = { "--line-length=120" }
--         }),
--         null_ls.builtins.formatting.isort,
--     }
-- })
-- require("mason").setup()
-- require("mason-lspconfig").setup()
-- require("mason-null-ls").setup({
--     automatic_setup = true,
-- })
-- require("dapui").setup()
-- require("dap-python").setup()
--
require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    }
}

-- require("codecompanion").setup({
--   adapters = {
--     anthropic = function()
--       return require("codecompanion.adapters").extend("anthropic", {
--         env = {
--             },
--       })
--     end,
--   },
-- })
