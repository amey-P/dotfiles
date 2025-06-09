-- for server, config in pairs(opts.servers) do
--     config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
--     lspconfig[server].setup(config)
-- end
vim.lsp.config['lua'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            }
        }
    }
}

vim.lsp.config['rust'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
    settings = {
    }
}

vim.lsp.config['python'] = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', '.git' },
    settings = {
    }
}

-- vim.lsp.config('ruff', {
--   init_options = {
--     settings = {
--       -- Ruff language server settings go here
--     }
--   }
-- })

vim.lsp.enable({
    'lua',
    'python',
    'rust'
})

-- Keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic in floating window' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Add diagnostics to location list' })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "LSP Format Buffer" })
vim.keymap.set("v", "<leader>cf", vim.lsp.buf.format, { desc = "LSP Format Selection" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Format Buffer" })
