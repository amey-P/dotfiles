-- Initialize Notes Module
-- This module sets up keybindings for capturing notes and todos.
-- Configuration is handled in `config.lua`.

local actions = require('config.notes.actions')

vim.keymap.set("n", "<leader>cc", actions.capture, { noremap = true, desc = "Capture (Todo/Epiphany/Research)" })
vim.keymap.set("n", "<leader>cr", actions.browse_research, { noremap = true, desc = "Browse Research Notes" })
vim.keymap.set("n", "<leader>ci", actions.show_todos, { noremap = true, desc = "Show Inbox" })