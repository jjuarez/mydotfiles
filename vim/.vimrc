" ----------------------------------------------------------------------------
"  Vundle setup
" ----------------------------------------------------------------------------
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle. Required!
Bundle 'gmarik/vundle'

" Language-specific syntax files
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-rails'
Bundle 'dougireton/vim-ps1'
Bundle 'vim-ruby/vim-ruby'
Bundle 'elzr/vim-json'

" Comment plugin
Bundle 'tpope/vim-commentary'

" Syntax check on buffer save
Bundle 'scrooloose/syntastic'

" Git plugins
Bundle 'tpope/vim-fugitive'
Bundle 'gregsexton/gitv'

" Lightweight support for Ruby's Bundler
Bundle 'tpope/vim-bundler'

" RVM
Bundle 'tpope/vim-rvm'

" Various editing plugins
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'nelstrom/vim-visual-star-search'
Bundle 'tpope/vim-endwise'
Bundle 'godlygeek/tabular'

" File managers/explorers
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/nerdtree'

" Colorschemes
Bundle 'altercation/vim-colors-solarized'

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" load the man plugin for a nice man viewer
runtime! ftplugin/man.vim

" ----------------------------------------------------------------------------
"  moving around, searching and patterns
" ----------------------------------------------------------------------------
set nostartofline
set incsearch	
set ignorecase
set smartcase

" ----------------------------------------------------------------------------
"  tags
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  displaying text
" ----------------------------------------------------------------------------
set scrolloff=3
set linebreak
set showbreak=?\ \
set sidescrolloff=2
set display+=lastline
set cmdheight=2

" Define characters to show when you show formatting
" stolen from https://github.com/tpope/vim-sensible
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  endif
endif

set number

" ----------------------------------------------------------------------------
"  syntax, highlighting and spelling
" ----------------------------------------------------------------------------
colorscheme darkblue
" colorscheme solarized
" set background=dark
" set colorcolumn=132

" ----------------------------------------------------------------------------
"  multiple windows
" ----------------------------------------------------------------------------
set laststatus=2
set hidden
set switchbuf=usetab " Jump to the 1st open window which contains
                      " specified buffer, even if the buffer is in
                      " another tab.
                      " TODO: Add 'split' if you want to split the
                      " current window for a quickfix error window.

set statusline=
set statusline+=buffer%-1.3n\ >
set statusline+=\ %{fugitive#statusline()}:
set statusline+=\ %F
set statusline+=\ %M
set statusline+=%R
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%=
set statusline+=\ %Y
set statusline+=\ <\ %{&fenc}
set statusline+=\ <\ %{&ff}
set statusline+=\ <\ %p%%
set statusline+=\ %l:
set statusline+=%02.3c 

set helpheight=30   

" ----------------------------------------------------------------------------
"  multiple tab pages
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  terminal
" ----------------------------------------------------------------------------
set ttyfast			      " this is the 21st century, people

" ----------------------------------------------------------------------------
"  using the mouse
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  GUI				      " Set these options in .gvimrc
" See help for 'setting-guifont' for tips on how to set guifont on Mac vs Windows
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  printing
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  messages and info
" ----------------------------------------------------------------------------
set showcmd
set ruler
set confirm

" ----------------------------------------------------------------------------
"  selecting text
" ----------------------------------------------------------------------------
set clipboard=unnamed	" Yank to the system clipboard by default

" ----------------------------------------------------------------------------
"  editing text			" TODO: look at these options
" ----------------------------------------------------------------------------
set backspace=indent,eol,start  "backspace over everything

" if v:version > 7.03 || v:version == 7.03 && has("patch541")
"   set formatoptions+=j
" endif

set showmatch 
set nojoinspaces
set completeopt+=longest 
set nrformats-=octal    

" ----------------------------------------------------------------------------
"  tabs and indenting
" ----------------------------------------------------------------------------
set smarttab              " <TAB> in front of line inserts 'shiftwidth' blanks
set shiftround            " round to 'shiftwidth' for "<<" and ">>" 
set expandtab
set tabstop=2

" ----------------------------------------------------------------------------
"  folding
" ----------------------------------------------------------------------------
set nofoldenable 		  " When opening files, all folds open by default

" ----------------------------------------------------------------------------
"  diff mode
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  mapping
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  reading and writing files
" ----------------------------------------------------------------------------
set autoread


" ----------------------------------------------------------------------------
"  the swap file
" ----------------------------------------------------------------------------
if has("win32") || has("win64")
  set directory=$TEMP
else
  " Vim will try this ordered list of directories for .swp files
  set directory=~/tmp,.,/var/tmp,/tmp
endif

" ----------------------------------------------------------------------------
"  command line editing
" ----------------------------------------------------------------------------
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
"  executing external commands
" ----------------------------------------------------------------------------

if has("win32") || has("gui_win32")
  if executable("PowerShell")
    " Set PowerShell as the shell for running external ! commands
    " http://stackoverflow.com/questions/7605917/system-with-powershell-in-vim
    set shell=PowerShell
    set shellcmdflag=-ExecutionPolicy\ RemoteSigned\ -Command
    set shellquote=\"
    " TODO: shellxquote must be a literal space character.
    " Fix my trim trailing whitespace command to not run automatically on save
    set shellxquote= 
  endif
endif

" ----------------------------------------------------------------------------
"  running make and jumping to errors
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  language specific
" ----------------------------------------------------------------------------

" ----------------------------------------------------------------------------
"  multi-byte characters
" ----------------------------------------------------------------------------
set encoding=utf-8

" ----------------------------------------------------------------------------
"  various
" ----------------------------------------------------------------------------
set gdefault                    " For :substitute, use the /g flag by default

" ----------------------------------------------------------------------------
" Autocmds
" ----------------------------------------------------------------------------

" Make gf work on Chef include_recipe lines
" Add all cookbooks/*/recipe dirs to Vim's path variable
autocmd BufRead,BufNewFile */cookbooks/*/recipes/*.rb setlocal path+=recipes;/cookbooks/**1


" ----------------------------------------------------------------------------
" Allow overriding these settings
" ----------------------------------------------------------------------------
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
