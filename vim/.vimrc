syntax enable
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set t_Co=256		" Terminal Colour
set mouse =""
set incsearch
set relativenumber
set number
set autoindent

set path+=**
set wildmenu

filetype plugin indent on  
set laststatus=2

colorscheme iceberg


set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'michaeljsmith/vim-indent-object'

Plug 'sjl/gundo.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'chrisbra/Colorizer'

call plug#end()

let g:vimwiki_list = [{'path': '~/vimwiki/',
                       \ 'syntax': 'markdown', 'ext': '.md'}]

let g:gundo_prefer_python3 = 1

set updatetime=100		" GitGutter update time

" Mappings
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>e :Files<CR>
nnoremap <Leader>/ :Rg<CR>

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

map <F4> :GundoToggle<CR>
