set nocompatible " like -N parameter remember to suppres the shell alias

" ----------------------------------------------------------------------------
"  Vundle setup
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Plugin 'gmarik/Vundle.vim'

Plugin 'kien/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tomtom/tcomment_vim'
Plugin 'elzr/vim-json'
Plugin 'vim-ruby/vim-ruby'
Plugin 'thoughtbot/vim-rspec'
Plugin 'rodjek/vim-puppet'
Plugin 'klen/python-mode'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'scrooloose/syntastic'
Plugin 'bling/vim-airline'
Plugin 'jpo/vim-railscasts-theme'
Plugin 'honza/vim-snippets'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'edkolev/tmuxline.vim'
Plugin 'altercation/vim-colors-solarized'


if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif


let mapleader=","

" ----------------------------------------------------------------------------
" syntax, highlighting and spelling
colorscheme solarized
set background=dark
" colorscheme railscasts



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


" ----------------------------------------------------------------------------
" Airline 
let g:airline_powerline_fonts=1
let g:airline_theme='tomorrow'
let g:airline#extensions#syntastic#enabled=1
let g:airline#extensions#tabline#enabled=1


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
