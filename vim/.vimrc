set nocompatible " like -N parameter remember to suppres the shell alias

" ----------------------------------------------------------------------------
"  Vundle setup
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-haml'
Bundle 'vim-ruby/vim-ruby'
Bundle 'hallison/vim-ruby-sinatra'
Bundle 'thoughtbot/vim-rspec'
Bundle 'ervandew/supertab'
Bundle 'elzr/vim-json'
Bundle 'mattboehm/vim-unstack'
Bundle 'scrooloose/syntastic'
Bundle 'nelstrom/vim-visual-star-search'
Bundle 'jpo/vim-railscasts-theme'
Bundle 'bling/vim-airline'
Bundle 'Blackrush/vim-gocode'
Bundle 'tomtom/tcomment_vim'
Bundle 'rodjek/vim-puppet'
Bundle 'ekalinin/Dockerfile.vim'

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif


let mapleader=","

" ----------------------------------------------------------------------------
" syntax, highlighting and spelling
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
set wildignore+=*.exe,*.swp,.DS_Store,.git,.svn
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
" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list =1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode' : 'passive' }
let g:syntastic_ruby_exec = '/usr/local/opt/rbenv/shims/ruby'


" ----------------------------------------------------------------------------
" Allow overriding these settings
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
