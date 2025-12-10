" =============================================================================
" Basic Settings
" =============================================================================

" Disable Vi compatibility
set nocompatible

" Enable syntax highlighting
syntax on

" Enable file type detection
filetype plugin indent on

" Set character encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,sjis

" =============================================================================
" UI Settings
" =============================================================================

" Show line numbers
set number

" Show relative line numbers
set relativenumber

" Highlight current line
set cursorline

" Show command in status line
set showcmd

" Show mode in status line
set showmode

" Enable wildmenu for command completion
set wildmenu
set wildmode=longest:full,full

" Show matching brackets
set showmatch

" Always show status line
set laststatus=2

" Display ruler (line and column number)
set ruler

" Minimal number of screen lines to keep above and below cursor
set scrolloff=5

" Enable mouse support
set mouse=a

" =============================================================================
" Color Scheme Settings
" =============================================================================

" Enable 24-bit colors
set termguicolors

" Set dark background
set background=dark

" Use slate color scheme
colorscheme slate

" Make background transparent
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

" =============================================================================
" Search Settings
" =============================================================================

" Enable incremental search
set incsearch

" Highlight search results
set hlsearch

" Case insensitive search
set ignorecase

" Smart case search (case sensitive if uppercase is used)
set smartcase

" =============================================================================
" Indent Settings
" =============================================================================

" Enable auto indent
set autoindent

" Enable smart indent
set smartindent

" Use spaces instead of tabs
set expandtab

" Tab width
set tabstop=2
set shiftwidth=2
set softtabstop=2

" =============================================================================
" File Settings
" =============================================================================

" Enable auto read when file is changed from outside
set autoread

" Enable backup
set backup
set backupdir=~/.vim/backup//

" Enable undo file
set undofile
set undodir=~/.vim/undo//

" Enable swap file
set swapfile
set directory=~/.vim/swap//

" =============================================================================
" Editing Settings
" =============================================================================

" Enable backspace
set backspace=indent,eol,start

" Don't wrap lines
set nowrap

" Show invisible characters
set list
set listchars=tab:→\ ,trail:·,extends:»,precedes:«,nbsp:⎵

" Use clipboard
set clipboard=unnamedplus

" =============================================================================
" Key Mappings
" =============================================================================

" Set leader key
let mapleader = " "

" Quick save
nnoremap <Leader>w :w<CR>

" Quick quit
nnoremap <Leader>q :q<CR>

" Clear search highlight
nnoremap <Leader><Space> :nohlsearch<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Better indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" =============================================================================
" Auto Commands
" =============================================================================

" Create necessary directories
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p", 0700)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p", 0700)
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p", 0700)
endif

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Return to last edit position when opening files
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" =============================================================================
" File Type Specific Settings
" =============================================================================

" Makefile
autocmd FileType make setlocal noexpandtab

" YAML
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2

" Python
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4

" Go
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4

" Markdown
autocmd FileType markdown setlocal wrap linebreak
