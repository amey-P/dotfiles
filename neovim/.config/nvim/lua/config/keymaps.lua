local options = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<Leader>s", ":w<Enter>", options)
vim.api.nvim_set_keymap("n", "Y", "y$", options)
vim.api.nvim_set_keymap("n", "n", "nzzzv", options)
vim.api.nvim_set_keymap("n", "N", "Nzzzv", options)
vim.api.nvim_set_keymap("n", "<Leader><Leader>", "<C-^>", options)

