set nocompatible " like -N parameter remember to suppres the shell alias
" ----------------------------------------------------------------------------
"  Vundle setup
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rvm'
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-fugitive'
Bundle 'slim-template/vim-slim'
Bundle 'ervandew/supertab'
Bundle 'dougireton/vim-ps1'
Bundle 'vim-ruby/vim-ruby'
Bundle 'elzr/vim-json'
Bundle 'thoughtbot/vim-rspec'
Bundle 'mattboehm/vim-unstack'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'nelstrom/vim-visual-star-search'
Bundle 'godlygeek/tabular'
Bundle 'kien/ctrlp.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'jpo/vim-railscasts-theme'
Bundle 'nanotech/jellybeans.vim'
Bundle 'bling/vim-airline'
Bundle 'Blackrush/vim-gocode'
Bundle 'dougireton/vim-chef'
Bundle 'evanmiller/nginx-vim-syntax'

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif


let mapleader=","

" ----------------------------------------------------------------------------
" syntax, highlighting and spelling
"colorscheme jellybeans
colorscheme railscasts


" ----------------------------------------------------------------------------
" moving around, searching and patterns
set nostartofline
set incsearch	
set ignorecase
set smartcase


" ----------------------------------------------------------------------------
" displaying text
set scrolloff=3
set linebreak
set showbreak=?\ \
set sidescrolloff=2
set display+=lastline
set cmdheight=2
set nowrap
set number




" ----------------------------------------------------------------------------
" multiple windows
set laststatus=2
set hidden
set switchbuf=usetab
set helpheight=30   


" ----------------------------------------------------------------------------
" terminal
set ttyfast			      " this is the 21st century, people


" ----------------------------------------------------------------------------
" messages and info
set showcmd
set ruler
set confirm


" ----------------------------------------------------------------------------
" selecting text
set clipboard=unnamed	" Yank to the system clipboard by default


" ----------------------------------------------------------------------------
" editing text			" TODO: look at these options
set backspace=indent,eol,start  "backspace over everything
set showmatch 
set nojoinspaces
set completeopt+=longest 
set nrformats-=octal    


" ----------------------------------------------------------------------------
" tabs and indenting
set smarttab              " <TAB> in front of line inserts 'shiftwidth' blanks
set shiftround            " round to 'shiftwidth' for "<<" and ">>" 
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent


" ----------------------------------------------------------------------------
" folding
set nofoldenable 		  " When opening files, all folds open by default


" ----------------------------------------------------------------------------
" reading and writing files
set autoread


" ----------------------------------------------------------------------------
" command line editing
set history=200
set wildmode=list:longest,full

" File tab completion ignores these file patterns
set wildignore+=*.exe,*.swp,.DS_Store
set wildmenu

" Add guard around 'wildignorecase' to prevent terminal vim error
if exists('&wildignorecase')
  set wildignorecase
endif


" ----------------------------------------------------------------------------
" multi-byte characters
set encoding=utf-8


" ----------------------------------------------------------------------------
" Autocmds
autocmd BufWritePre *.rb :%s/\s\+$//e
autocmd BufWritePre *.haml :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e
autocmd BufWritePre *.scss :%s/\s\+$//e
autocmd BufWritePre *.slim :%s/\s\+$//e
autocmd BufNewFile  * set noeol
autocmd BufRead,BufNewFile *.go set filetype=go


" ----------------------------------------------------------------------------
" Airline 
let g:airline_enable_syntastic=1
let g:airline_theme='jellybeans'
" let g:airline_powerline_fonts=1
" let g:airline#extensions#tabline#enabled=1


" ----------------------------------------------------------------------------
" NERDTree
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg' ]


" ----------------------------------------------------------------------------
" Syntastic
let g:syntastic_mode_map = { 'mode' : 'passive' }
let g:syntastic_ruby_exec = '~/.rvm/rubies/default/bin/ruby'


" ----------------------------------------------------------------------------
" CtrlP
nnoremap <silent> t :CtrlP<CR>
let g:ctrlp_working_path_mode=2
let g:ctrlp_by_filename=1
let g:ctrlp_max_files=400
let g:ctrlp_max_depth=5


" ----------------------------------------------------------------------------
" Allow overriding these settings
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

