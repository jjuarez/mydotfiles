set nocompatible " like -N parameter remember to suppres the shell alias
filetype plugin on

" Plug plugin management
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'ervandew/supertab'
Plug 'tomasr/molokai'
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'szw/vim-maximizer'
" Plug 'alpertuna/vim-header'
Plug 'w0rp/ale'
Plug 'tsandall/vim-rego'
Plug 'klen/python-mode'
Plug 'hashivim/vim-terraform'
Plug 'fatih/vim-go'
" Plug 'jjo/vim-cue'
" Plug 'NoahTheDuke/vim-just'
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
try
  colorscheme molokai
  let g:rehash256=1
  let g:colorscheme_bg='dark'
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
catch
   colorscheme default
endtry

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
if !has('nvim')
  set viminfo+=n~/.vim/.viminfo
else
  set viminfo+=n~/.local/shared/nvim/.shada
endif
let g:session_autosave='no'

"" lightline configuration
set laststatus=2
set noshowmode
if !has('gui_running')
  set t_Co=256
endif
let g:lightline = { 'colorscheme': 'wombat' }

"" Ale
let g:ale_python_flake8_options = '--max-line-length=132'

"" NERDTree
let NERDTreeShowHidden=1

"" Fix auto-indentation for YAML files
augroup yaml_fix
  autocmd!
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup end

"" Maximize current split or return to previous
noremap <C-w>m :MaximizerToggle<CR>

"" vim-header configuration
let g:header_field_author = "Javier Juarez"
let g:header_field_author_email = "jj@chainedto.cloud"
""map <F4> :AddHeader<CR>

"" Allow overriding these settings
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
