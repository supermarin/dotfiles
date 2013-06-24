set t_Co=256
" Vundle stuff
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'kien/ctrlp.vim'
Bundle 'tomasr/molokai'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Raimondi/delimitMate'
Bundle 'altercation/vim-colors-solarized'
Bundle 'chriskempson/base16-vim'
Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Bundle 'editorconfig/editorconfig-vim'
"Bundle 'scrooloose/syntastic'
"Bundle 'vim-ruby/vim-ruby'
"Bundle 'plasticboy/vim-markdown'

set encoding=utf-8
set nocompatible               " be iMproved
set smartindent
set autoindent
set autoindent
set smartindent
"When using p, adjust indent to the current line
nmap p ]p
filetype plugin indent on
filetype off                   " required!

" Set the background light from 7am to 7pm
let hour = strftime("%H")
if 7 <= hour && hour < 19
  colorscheme Tomorrow
else
  colorscheme molokai
endif
syntax enable

" Speed up pressing O after Esc. Changes the timeout of terminal escaping
set timeout timeoutlen=5000 ttimeoutlen=20
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
"set mouse=r
" Powerline
set rtp+=/Users/mneorr/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim
set laststatus=2
let g:Powerline_symbols = 'fancy'
" Real time search and highlight
set incsearch
set ignorecase
set smartcase
set hlsearch

" Cursor / carret switching
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Hooking with system clipboard
if has("clipboard") " If the feature is available
  set clipboard=unnamed " copy to the system clipboard
endif

" GUI STUFF
if has('gui_running')
  set guifont=Monaco\ for\ Powerline:h13    " set fonts for gui vim
  "set transparency=5        " set transparent window
  set guioptions=egmrt  " hide the gui menubar
endif

" CocoaPods and Podfiles
au BufRead,BufNewFile *.podspec,Podfile set ft=ruby
" JSON
au BufNewFile,BufRead *.json set ai filetype=javascript

" Mappings
map <leader>r :w<CR>:!ruby %<CR>
