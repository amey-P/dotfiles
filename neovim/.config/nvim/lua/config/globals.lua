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
vim.g.colorcolumn = "81"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}		-- Autocompletion Configuration

-- Folding
vim.opt.foldenable = false
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = "*", -- Adjust the pattern if needed
  command = "setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()"
})
