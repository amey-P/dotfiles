require('nvim-treesitter.configs').setup({
    ensure_installed = { "elixir", "heex", "eex" }, -- Automatically install these
    highlight = {
        enable = true,                            -- This is the critical line
        additional_vim_regex_highlighting = false,
    },
})

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

vim.lsp.config['lua'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files (API, built-ins)
                -- AND your installed plugins
                library = vim.api.nvim_get_runtime_file("", true),
                -- Disable the "Do you need to configure your environment?" prompt
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

vim.lsp.config['rust'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
    settings = {
        inlayHints = {
            bindingModeHints = { enable = true },
            chainingHints = { enable = true },
            closingBraceHints = { enable = true, minLines = 25 },
            closureReturnTypeHints = { enable = "always" },
            lifetimeElisionHints = { enable = "always" },
            parameterHints = { enable = true },
        }
    }
}

vim.lsp.config['ruff'] = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    settings = {
    }
}

vim.lsp.config['pyright'] = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
}

vim.lsp.config['elixir'] = {
    cmd = { 'elixir-ls' },
    filetypes = { 'elixir', 'heex', 'ex', 'exs' },
    root_markers = { 'mix.exs', '.git' },
    settings = {
        elixirLS = {
            dialyzerEnabled = true,
            fetchDeps = false,
            enableTestLenses = true,
            suggestSpecs = true,
        },
    },
}

vim.lsp.config['markdown'] = {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'markdown.mdx' },
    settings = {},
}

local servers = {
    'lua',
    'ruff',
    'pyright',
    'rust',
    'elixir',
    'markdown'
}
vim.lsp.enable(servers)

-- Keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic in floating window' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Add diagnostics to quickfix list' })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "LSP Format Buffer" })
vim.keymap.set("v", "<leader>cf", vim.lsp.buf.format, { desc = "LSP Format Selection" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>ci", vim.lsp.buf.incoming_calls, { desc = "Go to Incoming_calls" })
vim.keymap.set("n", "<leader>co", vim.lsp.buf.outgoing_calls, { desc = "Go to outgoing_calls" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Format Buffer" })

local function lsp_restart()
    vim.lsp.enable(servers, false)
    vim.lsp.enable(servers, true)
end

vim.keymap.set("n", "<leader>lr", lsp_restart, { desc = "Restart LSP Server" })
