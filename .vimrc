set shell=/bin/bash
set t_Co=256
set encoding=utf-8
set nocompatible

set nobackup
set nowritebackup
set noswapfile

" Vundle stuff
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
" Vundles
Bundle 'scrooloose/syntastic'
Bundle 'Valloric/YouCompleteMe'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Raimondi/delimitMate'
Bundle 'chriskempson/base16-vim'
Bundle 'w0ng/vim-hybrid'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'b4winckler/vim-objc'
Bundle 'tpope/vim-fugitive'
Bundle 'bling/vim-airline'
" SNIPMATE only
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"
Bundle 'honza/vim-snippets'
"
"Bundle 'tomasr/molokai'
"Bundle 'Yggdroot/indentLine'
Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
"Bundle 'vim-ruby/vim-ruby'
"Bundle 'plasticboy/vim-markdown'

" indentations
set smartindent
set autoindent
set ts=2 sts=2 sw=2
set expandtab
set smarttab
" lang specific indentations
autocmd Filetype javascript setlocal ts=4 sts=4 sw=4

" syntax
syntax on
filetype on
filetype plugin on
filetype indent on

" Set the background light from 7am to 7pm
"let hour = strftime("%H")
"if 7 <= hour && hour < 19
  "colorscheme Tomorrow
"else
  "colorscheme Tomorrow-Night
  "colorscheme base16-tomorrow
  colorscheme hybrid
"endif

" Speed up pressing O after Esc. Changes the timeout of terminal escaping
set timeout timeoutlen=5000 ttimeoutlen=20
" Line numbers
set number
" Whitespace
set listchars=trail:·,tab:▸\ ,eol:¬
set list
" Mouse scrolling
set mouse=a
"set mouse=r
" Airline
set laststatus=2
let g:airline_theme='powerlineish'
let g:airline_enable_fugitive=1
  " powerline symbols
  "let g:airline_left_sep = ''
  "let g:airline_left_alt_sep = ''
  "let g:airline_right_sep = ''
  "let g:airline_right_alt_sep = ''
  "let g:airline_fugitive_prefix = ' '
  "let g:airline_readonly_symbol = ''
  "let g:airline_linecolumn_prefix = ' '
"

" Real time search and highlight
set incsearch
set hlsearch
set ignorecase
set smartcase

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
  "set guifont=Monaco\ for\ Powerline:h15    " set fonts for gui vim
  set guifont=Menlo:h15    " set fonts for gui vim
  "set transparency=5        " set transparent window
  set guioptions=egmrt  " hide the gui menubar
endif

" CocoaPods and Podfiles
au BufRead,BufNewFile *.podspec,Podfile set ft=ruby
" JSON
au BufRead,BufNewFile *.json set ai filetype=javascript
" Markdown
au BufRead,BufNewFile *.md set ft=markdown
" Mappings
let mapleader = ','

map <leader>r :w<CR>:!ruby %<CR>
map <leader>w :q<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
command WW :execute ':silent w !sudo tee % > /dev/null' | :edit!
"
" When using p, adjust indent to the current line
nmap p ]p
" Ctrl + S for save
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
inoremap <c-s> <c-o>:Update<CR>
" Rubymotion
map <leader>m :w<CR>:!rake<CR>
inoremap <leader>m <c-o>:Update<CR> <c-o>:!rake<CR>
map <leader>t :w<CR>:!rake spec<CR>
inoremap <leader>t <c-o>:w<CR> <c-o>:!rake spec<CR>

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" CtrlP - Open files in a new tab
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': [],
  \ 'AcceptSelection("t")': ['<cr>', '<c-m>'],
  \ }
