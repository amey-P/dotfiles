-- General Configuration
vim.opt.guifont = "Fira Code:h9"				-- Font for gui client
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.showbreak = "↳"
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.colorcolumn = "81"
vim.g.airline_theme = "tomorrow"
vim.g.mapleader = " "
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}		-- Autocompletion Configuration

-- Neovide Settings
vim.g.neovide_cursor_animation_length = 0.03
vim.g.neovide_cursor_trail_length = 0.0
vim.g.neovide_cursor_vfx_mode = "sonicboom"