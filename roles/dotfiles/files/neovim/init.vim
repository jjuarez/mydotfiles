set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

source ~/.vimrc

if exists('nvim')
  tnoremap <Esc> <C-\><C-n>
endif
