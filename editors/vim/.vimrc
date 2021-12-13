set nocompatible " like -N parameter remember to suppres the shell alias
filetype plugin on

" Plug plugin management
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'tomasr/molokai'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'ryanoasis/vim-devicons'
Plug 'ervandew/supertab'
Plug 'junegunn/limelight.vim'
" Plug 'jiangmiao/auto-pairs'
Plug 'fatih/vim-go'
Plug 'pearofducks/ansible-vim'
Plug 'klen/python-mode'
Plug 'hashivim/vim-terraform'
Plug 'leafgarland/typescript-vim'
Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'
Plug 'tsandall/vim-rego'

call plug#end()

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

let mapleader=","

"" This configuration helps with the slowliness of ruby plugin
set regexpengine=1

"" fzf
set rtp+=/usr/local/opt/fzf

" Assume that filetype=sh are posix and therefore will support proper `$(...)`
" See:
" * https://git.io/fjngy
" * https://github.com/tpope/vim-sensible/issues/140
let g:is_posix = 1

"" The Color Scheme
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

if isdirectory(expand("~/.vim/plugged/molokai"))
  colorscheme molokai
  let g:molokai_original=1
  let g:rehash256=1
endif

execute "set colorcolumn=" . join(range(133,335), ',')

"" Show trailing whitespace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=None guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\\t/

"" moving around, searching and patterns
set nostartofline
set incsearch	
set ignorecase
set smartcase
set hlsearch

"" displaying text
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

"" multiple windows
set hidden
set laststatus=2
set switchbuf=usetab
set helpheight=30   

"" terminal
set ttyfast

"" messages and info
set showcmd
set ruler
set confirm

"" selecting text
set clipboard=unnamed	" Yank to the system clipboard by default

"" editing text	
set backspace=indent,eol,start  "backspace over everything OSX fix
set showmatch 
set nojoinspaces
set completeopt+=longest 
set nrformats-=octal    

"" tabs and indenting
set smartindent
set smarttab              " <TAB> in front of line inserts 'shiftwidth' blanks
set shiftround            " round to 'shiftwidth' for "<<" and ">>" 
set expandtab
set backspace=2
set scrolloff=2
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent

"" folding
set nofoldenable 		  " When opening files, all folds open by default

"" reading and writing files
set autoread

"" command line editing
set history=50
set wildmode=list:longest,full

"" File tab completion ignores these file patterns
set wildignore+=*.exe,*.o,*.obj,*.pyc,*.class,vendor/gems/*,*.swp,.DS_Store,.git,.svn
set wildmenu
set wildmode=list:longest,list:full

"" List of hidden charts
"" set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

"" Add guard around 'wildignorecase' to prevent terminal vim error
if exists('&wildignorecase')
  set wildignorecase
endif

"" multi-byte characters
set encoding=utf-8

"" Mappings
map ; :Buffers<CR>
map <Leader>/ :nohlsearch<CR>

"" viminfo sessions
set viminfo=%,<800,'10,/50,:100,h,f0,n~/.vim/.viminfo
let g:session_autosave='no'

"" PyMode
let g:pymode_lint_ignore = "E501,W"

"" Markdown
let g:markdown_fenced_languages = [ 'python', 'yaml', 'bash=sh', 'go' ]

"" Fix auto-indentation for YAML files
augroup yaml_fix
  autocmd!
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup end

"" Allow overriding these settings
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

