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
    use 'hrsh7th/nvim-cmp' -- Completion Framework
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'
    use 'mfussenegger/nvim-dap-python'
    use 'github/copilot.vim'

    -- use {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}
    use 'mechatroner/rainbow_csv'
    use { "ellisonleao/glow.nvim" }
    use 'nvim-telescope/telescope-symbols.nvim'

    use {
        "nvim-neorg/neorg",
        run = ":Neorg sync-parsers",
    }

    use 'wakatime/vim-wakatime'
end)

-- Setups
require('gitsigns').setup()
require("nvim-tree").setup()
require('Comment').setup()
require("project_nvim").setup()
require("telescope").load_extension("projects")
-- require("flutter-tools").setup()
-- require("telescope").load_extension("flutter")
require("mason").setup()
require("mason-lspconfig").setup()
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

