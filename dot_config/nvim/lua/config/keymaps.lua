local options = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<Leader>s", ":w<Enter>", options)
vim.api.nvim_set_keymap("n", "Y", "y$", options)
vim.api.nvim_set_keymap("n", "n", "nzzzv", options)
vim.api.nvim_set_keymap("n", "N", "Nzzzv", options)

vim.api.nvim_set_keymap("n", "<Leader><Leader>", "<C-^>", options)
vim.api.nvim_set_keymap("n", "<Leader>qc", "<cmd>cclear<cr>", options)

-- On Fly Config
vim.api.nvim_set_keymap("n", "<Leader>x", "<cmd>source %<cr>", options)
vim.keymap.set("n", "<Leader>X", function()
    local line = vim.api.nvim_get_current_line()
    local func = loadstring(line)
    if func == nil then
        vim.notify("No code to execute", vim.log.levels.ERROR)
    else
        func()
    end
end, options)
