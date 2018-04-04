set nocompatible " like -N parameter remember to suppres the shell alias

" ----------------------------------------------------------------------------
"  Vundle setup
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

Plugin 'gmarik/Vundle.vim'
" Utils
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'ervandew/supertab'
Plugin 'tomtom/tlib_vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'DataWraith/auto_mkdir'
Plugin 'tpope/vim-unimpaired'
Plugin 'w0rp/ale'
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'hashivim/vim-terraform'
Plugin 'fatih/vim-go'
" Themes
Plugin 'tomasr/molokai'
Plugin 'ryanoasis/vim-devicons'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'


if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif


let mapleader=","


" ----------------------------------------------------------------------------
" syntax, highlighting and spelling
set background=dark  
let g:molokai_original=1  
let g:rehash256=1  
set t_Co=256  
colorscheme molokai

" Show trailing whitespace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\\t/


" ----------------------------------------------------------------------------
" moving around, searching and patterns
set nostartofline
set incsearch	
set ignorecase
set smartcase
set hlsearch


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
set cursorline
set cuc cul"


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
" editing text	
set backspace=indent,eol,start  "backspace over everything OSX fix
set showmatch 
set nojoinspaces
set completeopt+=longest 
set nrformats-=octal    


" ----------------------------------------------------------------------------
" tabs and indenting
set smartindent
set smarttab              " <TAB> in front of line inserts 'shiftwidth' blanks
set shiftround            " round to 'shiftwidth' for "<<" and ">>" 
set expandtab
set backspace=2
set scrolloff=2
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
set wildignore+=*.exe,*.o,*.obj,*.pyc,*.rbc,*.class,vendor/gems/*,*.swp,.DS_Store,.git,.svn
set wildmenu
set wildmode=list:longest,list:full

" Add guard around 'wildignorecase' to prevent terminal vim error
if exists('&wildignorecase')
  set wildignorecase
endif


" ----------------------------------------------------------------------------
" multi-byte characters
set encoding=utf-8


" ----------------------------------------------------------------------------
" Airline 
let g:airline_powerline_fonts=1
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled=1


" ----------------------------------------------------------------------------
" Syntastic 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1


" ----------------------------------------------------------------------------
" Mappings
" toggle the search highlight mode
map ; :Buffers<CR>
map <Leader>/ :nohlsearch<CR>
" Open NERDTree
map <Leader>q :NERDTreeToggle<CR>
" fzf
map <Leader>t :Files<CR>
map <Leader>r :Tags<CR>


" ----------------------------------------------------------------------------
" viminfo sessions
set viminfo=%,<800,'10,/50,:100,h,f0,n~/.vim/.viminfo
let g:session_autosave='no'


" ----------------------------------------------------------------------------
" Terraform plugin setup
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1

" ----------------------------------------------------------------------------
" Ruby slow workaround
augroup ft_rb
  au!
  au FileType ruby setlocal re=1 foldmethod=manual
augroup END

"
" ----------------------------------------------------------------------------
" Allow overriding these settings
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

