local options = { noremap = true, silent = true }

-- Global
vim.api.nvim_set_keymap("n", "<Leader>s", ":w<Enter>", options)
vim.api.nvim_set_keymap("n", "Y", "y$", options)
vim.api.nvim_set_keymap("n", "n", "nzzzv", options)
vim.api.nvim_set_keymap("n", "N", "Nzzzv", options)
vim.api.nvim_set_keymap("n", "<Leader><Leader>", "<C-^>", options)

-- Navigation
vim.api.nvim_set_keymap("n", "<F2>", ":NvimTreeToggle<Enter>", options)

vim.api.nvim_set_keymap("n", "<Leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", options)
vim.api.nvim_set_keymap("n", "<Leader>f/", "<cmd>lua require('telescope.builtin').live_grep()<cr>", options)
vim.api.nvim_set_keymap("n", "<Leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", options)
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", options)
vim.api.nvim_set_keymap("n", "<Leader>fd", ":Telescope diagnostics<cr>", options)
vim.api.nvim_set_keymap("n", "<Leader>fp", ":Telescope projects<cr>", options)
vim.api.nvim_set_keymap("n", "<Leader>gc", ":Telescope git_commits<cr>", options)
vim.api.nvim_set_keymap("n", "<Leader>gf", ":Telescope git_files<cr>", options)
vim.api.nvim_set_keymap("n", "<Leader>gs", ":Telescope git_stash<cr>", options)
vim.api.nvim_set_keymap("n", "<Leader>gg", ":Telescope git_status<cr>", options)
vim.api.nvim_set_keymap("i", "<C-e>", "<Esc>h:Telescope symbols<cr>", options)

vim.api.nvim_set_keymap("n", "]q", ":cnext<cr>", options)
vim.api.nvim_set_keymap("n", "[q", ":cprev<cr>", options)
vim.api.nvim_set_keymap("n", "[]", ":cclose<cr>", options)

-- LSP
-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
-- vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
-- vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
-- vim.keymap.set('n', '<Leader>wl', function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, bufopts)
vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<Leader>oc', vim.lsp.buf.outgoing_calls, bufopts)
vim.keymap.set('n', '<Leader>ic', vim.lsp.buf.incoming_calls, bufopts)
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', '<Leader>cf', vim.lsp.buf.format, bufopts)
vim.keymap.set('i', '<M-o>', "<C-o>:Copilot panel<CR>", bufopts)
vim.keymap.set('i', '<M-d>', "<C-o>:Copilot disable<CR>", bufopts)
vim.keymap.set('i', '<M-a>', "<C-o>:Copilot enable<CR>", bufopts)
--
-- Misc Language Tools
vim.keymap.set('v', '<leader>]', ':Gen<CR>')
vim.keymap.set('n', '<leader>]', ':Gen<CR>')
vim.keymap.set('n', '<F8>', ':SymbolsOutline<CR>')
vim.keymap.set('i', '<F8>', ':SymbolsOutline<CR>')

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

-- DAP
vim.keymap.set('n', '<F5>', ":lua require('dapui').toggle()<CR>", options)
vim.keymap.set('n', '<leader>b', ":lua require('dap').toggle_breakpoint()<CR>", options)
vim.keymap.set('n', '<leader>B', ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", options)
vim.keymap.set('n', '<leader>dc', ":lua require('dap').continue()<CR>", options)
vim.keymap.set('n', '<leader>dn', ":lua require('dap').step_over()<CR>", options)
vim.keymap.set('n', '<leader>ds', ":lua require('dap').step_into()<CR>", options)
vim.keymap.set('n', '<leader>do', ":lua require('dap').step_out()<CR>", options)
vim.keymap.set('n', '<leader>dt', ":lua require('dap').terminate()<CR>", options)

-- Neorg
vim.keymap.set('n', '<leader>nn', ":Neorg index<CR>", options)
vim.keymap.set('n', '<leader>nw', require('notetaking').switch_workspace, options)
vim.keymap.set('n', '<localleader>r', ":Neorg return<CR>", options)
vim.keymap.set('n', '<localleader>t', ":Neorg journal today<CR>", options)
vim.keymap.set('n', '<localleader>y', ":Neorg journal yesterday<CR>", options)
vim.keymap.set('n', '<localleader>tu', ":Neorg journal toc update<CR>", options)
-- vim.keymap.set('n', '<localleader>i', ":Neorg journal toc open<CR>", options)
-- vim.keymap.set('n', '<localleader>e', ":Neorg keybind all core.looking-glass.magnify-code-block<CR>", options)
vim.keymap.set('n', '<localleader>mi', ":Neorg inject-metadata<CR>", options)
vim.keymap.set('n', '<localleader>mu', ":Neorg update-metadata<CR>", options)
vim.keymap.set('n', '<localleader>is', ":Neorg generate-workspace-summary<CR>", options)
-- Linking
vim.keymap.set('n', '<localleader>f', ":Telescope neorg find_norg_files<CR>", options)
vim.keymap.set('n', '<localleader>f', ":Telescope neorg search_headings<CR>", options)
vim.keymap.set('n', '<localleader>lf', ":Telescope neorg insert_file_link<CR>", options)
vim.keymap.set('n', '<localleader>lh', ":Telescope neorg search_headings<CR>", options)
vim.keymap.set('n', '<localleader>bf', ":Telescope neorg find_backlinks<CR>", options)
vim.keymap.set('n', '<localleader>bh', ":Telescope neorg find_header_backlinks<CR>", options)


-- Misc
vim.keymap.set('n', "<F9>", ":FloatermToggle<cr>", options)
vim.api.nvim_set_keymap("n", "<F4>", ":UndotreeToggle<Enter>", options)
