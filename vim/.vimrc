set nocompatible " like -N parameter remember to suppres the shell alias

" ----------------------------------------------------------------------------
"  Vundle setup
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Plugin 'gmarik/Vundle.vim'
" Utils
Plugin 'mileszs/ack.vim'
Plugin 'tomtom/tlib_vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'w0rp/ale'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'majutsushi/tagbar'
Plugin 'gabrielelana/vim-markdown'
Plugin 'andrewstuart/vim-kubernetes'
Plugin 'ervandew/supertab'
Plugin 'wlemuel/vim-tldr'
" Syntax
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'hashivim/vim-terraform'
Plugin 'fatih/vim-go'
Plugin 'pearofducks/ansible-vim'
Plugin 'vim-scripts/bats.vim'
Plugin 'klen/python-mode'
Plugin 'towolf/vim-helm'
" Themes
Plugin 'tomasr/molokai'
Plugin 'ryanoasis/vim-devicons'
Plugin 'itchyny/lightline.vim'

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

if !has('gui_running')
  set t_Co=256  
endif

let mapleader=","

" This configuration helps with the slowliness of ruby plugin
set regexpengine=1

" Assume that filetype=sh are posix and therefore will support proper `$(...)`
" See:
" * https://git.io/fjngy
" * https://github.com/tpope/vim-sensible/issues/140
let g:is_posix = 1

" syntax, highlighting and spelling
set background=dark
"let g:molokai_original=1
let g:rehash256=1

" The Color Scheme
colorscheme molokai
execute "set colorcolumn=" . join(range(133,335), ',')

" Show trailing whitespace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\\t/

" moving around, searching and patterns
set nostartofline
set incsearch	
set ignorecase
set smartcase
set hlsearch

" displaying text
set scrolloff=3
set linebreak
set showbreak=?\ \
set sidescrolloff=2
set display+=lastline
set cmdheight=2
set nowrap
set number
set cursorline
set cuc cul"

" multiple windows
set laststatus=2
set hidden
set switchbuf=usetab
set helpheight=30   

" terminal
set ttyfast

" messages and info
set showcmd
set ruler
set confirm

" selecting text
set clipboard=unnamed	" Yank to the system clipboard by default

" editing text	
set backspace=indent,eol,start  "backspace over everything OSX fix
set showmatch 
set nojoinspaces
set completeopt+=longest 
set nrformats-=octal    

" tabs and indenting
set smartindent
set smarttab              " <TAB> in front of line inserts 'shiftwidth' blanks
set shiftround            " round to 'shiftwidth' for "<<" and ">>" 
set expandtab
set backspace=2
set scrolloff=2
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent

" folding
set nofoldenable 		  " When opening files, all folds open by default

" reading and writing files
set autoread

" command line editing
set history=200
set wildmode=list:longest,full

" File tab completion ignores these file patterns
set wildignore+=*.exe,*.o,*.obj,*.pyc,*.class,vendor/gems/*,*.swp,.DS_Store,.git,.svn
set wildmenu
set wildmode=list:longest,list:full

" Add guard around 'wildignorecase' to prevent terminal vim error
if exists('&wildignorecase')
  set wildignorecase
endif

" multi-byte characters
set encoding=utf-8

" Mappings
map ; :Buffers<CR>
map <Leader>/ :nohlsearch<CR>

" viminfo sessions
set viminfo=%,<800,'10,/50,:100,h,f0,n~/.vim/.viminfo
let g:session_autosave='no'

" Terraform plugin setup
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1

" ALE linters setup
let g:ale_completion_enabled=1
let g:ale_change_sign_column_color=1

" PyMode
let g:pymode_lint_ignore = "E501,W"

" Allow overriding these settings
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

