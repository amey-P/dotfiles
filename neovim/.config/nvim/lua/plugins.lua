-- Plugins
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    use 'cocopon/iceberg.vim'
    use 'airblade/vim-rooter'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'
    use 'kyazdani42/nvim-tree.lua'
    use 'numToStr/Comment.nvim'
    use 'tpope/vim-surround'
    -- use 'tpope/vim-speeddating'
    use 'tpope/vim-repeat'

    use { 'nvim-treesitter/nvim-treesitter' }
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use 'ahmedkhalf/project.nvim'
    use 'voldikss/vim-floaterm'
    use 'mbbill/undotree'
    use 'liuchengxu/vista.vim'

    -- use 'amey-P/vim-snippets'
    -- use 'L3MON4D3/LuaSnip'
    use 'williamboman/mason.nvim'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason-lspconfig.nvim'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'jay-babu/mason-null-ls.nvim'
    use 'hrsh7th/nvim-cmp' -- Completion Framework
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
    use 'mfussenegger/nvim-dap-python'
    use 'github/copilot.vim'

    use {
        'akinsho/flutter-tools.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
    }
    use 'mechatroner/rainbow_csv'
    use { "ellisonleao/glow.nvim" }
    use 'nvim-telescope/telescope-symbols.nvim'

    use {
        "nvim-neorg/neorg",
        run = ":Neorg sync-parsers",
    }

    use 'wakatime/vim-wakatime'
    use 'David-Kunz/gen.nvim'
end)

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
require("flutter-tools").setup()
require("telescope").load_extension("flutter")

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length=120" }
        }),
        null_ls.builtins.formatting.isort,
    }
})
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-null-ls").setup({
    automatic_setup = true,
})
require("dapui").setup()
require("dap-python").setup()

require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    }
}
