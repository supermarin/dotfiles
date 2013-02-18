set encoding=utf-8
set nocompatible               " be iMproved
set smartindent
set autoindent
filetype plugin on
filetype indent on
filetype off                   " required!

colorscheme molokai
:syntax on

" Speed up pressing O after Esc
set timeout timeoutlen=5000 ttimeoutlen=100
" Line numbers
set number
" Indentations
set expandtab
setlocal tabstop=2
setlocal shiftwidth=2
" Whitespace
set listchars=trail:·,tab:▸\ ,eol:¬
set list
" Remap leader key
let mapleader = ','
" Mouse scrolling
set mouse=a
" Powerline
set rtp+=/Users/mneorr/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim
set laststatus=2
let g:Powerline_symbols = 'fancy'

" Cursor / carret switching
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" GUI STUFF
if has('gui_running')
  set guifont=Monaco\ for\ Powerline:h12    " set fonts for gui vim
  set transparency=5        " set transparent window
  set guioptions=egmrt  " hide the gui menubar
endif


" Vundle stuff
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'wincent/Command-T'
Bundle 'scrooloose/nerdcommenter'
"Bundle 'plasticboy/vim-markdown'
