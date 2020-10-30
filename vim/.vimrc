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

	" Basic
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	Plug 'michaeljsmith/vim-indent-object'

	" Functional
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'vimwiki/vimwiki'
	Plug 'SirVer/ultisnips'
	Plug 'honza/vim-snippets'
	Plug 'itchyny/calendar.vim'

	" Programming
	Plug 'tpope/vim-fugitive'
	Plug 'dense-analysis/ALE'
	Plug 'neoclide/coc.nvim'
	Plug 'neoclide/coc-python'

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

" Mappings
	nnoremap <Leader>b :Buffers<CR>
	nnoremap <Leader>e :Files<CR>
	nnoremap <Leader>f :Rg<CR>
	nnoremap <Leader>/ :BLines<CR>
	nnoremap <Leader>// :BLines<CR>

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)
	" " GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" " Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>

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
