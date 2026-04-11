" General Settings
	syntax enable
	filetype plugin indent on  
	set nocompatible              " be iMproved, required
	set t_Co=256		" Terminal Colour
	set mouse =""
	set incsearch
	set autoindent
	set path+=**
	set wildmenu
	set hidden		" Change buffer without saving
	set relativenumber
	set number
	set laststatus=2
	set backspace=indent,eol,start
	set showbreak=↳

	colorscheme iceberg

"Plugins
	call plug#begin('~/.vim/plugged')

	" Editing
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	Plug 'michaeljsmith/vim-indent-object'
	Plug 'moll/vim-bbye'

	" Utilities and Navigation
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'vimwiki/vimwiki'
	Plug 'itchyny/calendar.vim'

	" Programming Utils
	Plug 'SirVer/ultisnips'
	Plug 'amey-P/vim-snippets'
	Plug 'tpope/vim-fugitive'
	Plug 'dense-analysis/ALE'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'mattn/vim-lsp-settings'
	Plug 'andreypopp/asyncomplete-ale.vim'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
	Plug 'rhysd/vim-lsp-ale'

	" Visual
	Plug 'itchyny/lightline.vim'
	Plug 'sjl/gundo.vim'
	Plug 'airblade/vim-gitgutter'
	Plug 'chrisbra/Colorizer'
	Plug 'liuchengxu/vista.vim'

	call plug#end()

" Plugin Configuration
	" VimWiki
	let g:vimwiki_list = [{'path': '~/vimwiki/',
			       \ 'syntax': 'markdown', 'ext': '.md'}]

	" Gundo
	let g:gundo_prefer_python3 = 1

	"GitGutter
	set updatetime=100

	" Netrw
	let g:netrw_liststyle = 3
	let g:netrw_browse_split = 4
	let g:netrw_altv = 1
	let g:netrw_winsize = 25
	let g:netrw_banner = 0
	let g:netrw_list_hide = &wildignore

	" LightLine
	set noshowmode
	let g:lightline = {
	      \ 'colorscheme': 'powerline',
	      \ 'active': {
	      \   'left': [ [ 'mode', 'paste' ],
	      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
	      \ },
	      \ 'component_function': {
	      \   'gitbranch': 'FugitiveHead'
	      \ },
	      \ }

	" Asyncompleter

	" LSP
		" General
		let g:lsp_diagnostics_enabled = 0	" Diagnostics done by ALE not LSP

		" Mappings
		function! s:on_lsp_buffer_enabled() abort
		    setlocal omnifunc=lsp#complete
		    setlocal signcolumn=yes
		    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
		    nmap <buffer> gd <plug>(lsp-definition)
		    nmap <buffer> gs <plug>(lsp-document-symbol-search)
		    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
		    nmap <buffer> gr <plug>(lsp-references)
		    nmap <buffer> gi <plug>(lsp-implementation)
		    nmap <buffer> gt <plug>(lsp-type-definition)
		    nmap <buffer> <leader>rn <plug>(lsp-rename)
		    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
		    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
		    nmap <buffer> K <plug>(lsp-hover)
		endfunction
		" Enable mappings if has language server installed
		augroup lsp_install
		    au!
		    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
		    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
		augroup END

		" Folding
		" set foldmethod=expr
		"   \ foldexpr=lsp#ui#vim#folding#foldexpr()
		"   \ foldtext=lsp#ui#vim#folding#foldtext()
	
" Mappings
	" Global
	nnoremap Y y$
	nnoremap n nzzzv
	nnoremap N Nzzzv


	" Navigation
	nnoremap <Leader>b :Buffers<CR>
	nnoremap <Leader>e :Files<CR>
	nnoremap <Leader>f :Rg<CR>
	nnoremap <Leader>/ :Lines<CR>
	nnoremap <Leader>C :Commands<CR>
	nnoremap <Leader>H :Helptags!<CR>

	" Linter and LSP
	nnoremap <Leader>fx :ALEFix<CR>

	" Vista Toggle
	nnoremap <F8> :Vista!!<CR>

	" Gundo Toggle
	nnoremap <F5> :GundoToggle<CR>

	" Netrw Toggle
	nnoremap <F4> :call NetrwToggle()<CR>


" Custom Functions
	let g:NetrwIsOpen=0

	function! NetrwToggle()
	    if g:NetrwIsOpen
		let i = bufnr("$")
		while (i >= 1)
		    if (getbufvar(i, "&filetype") == "netrw")
			silent exe "bwipeout " . i 
		    endif
		    let i-=1
		endwhile
		let g:NetrwIsOpen=0
	    else
		let g:NetrwIsOpen=1
		silent Lexplore
	    endif
	endfunction
