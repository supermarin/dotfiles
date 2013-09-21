" General Vim Behavior
set shell=/bin/bash
set t_Co=256
set encoding=utf-8
set nocompatible

set nobackup
set nowritebackup
set noswapfile

" Plugins
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
" Color schemes
Bundle 'chriskempson/base16-vim'
Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Bundle 'w0ng/vim-hybrid'
" Editor features
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/syntastic'
Bundle "rking/ag.vim"
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
Bundle 'Tagbar'
Bundle 'Valloric/YouCompleteMe'
" Text editing enhancements
Bundle 'SirVer/ultisnips'
Bundle 'scrooloose/nerdcommenter'
Bundle "tpope/vim-surround"
Bundle 'Raimondi/delimitMate'
Bundle 'editorconfig/editorconfig-vim'
" Dash
Bundle 'rizzatti/funcoo.vim'
Bundle 'rizzatti/dash.vim'

" syntax
syntax on
filetype on
filetype plugin on
filetype indent on

" indentations
set smartindent
set autoindent
set ts=4 sts=4 sw=4
set expandtab
set smarttab

" lang specific indentations
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2

" Set the background light from 7am to 7pm
let hour = strftime("%H")
if 7 <= hour && hour < 19
    colorscheme Tomorrow
else
    colorscheme hybrid
endif

" Speed up pressing O after Esc. Changes the timeout of terminal escaping
set timeout timeoutlen=5000 ttimeoutlen=10

" Line numbers
set number

" Whitespace
set listchars=trail:·,tab:▸\ ,eol:¬
set list


" Auto centering"
nmap N Nzz
nmap n nzz
nmap G Gzz
nmap } }zz
nmap { {zz

" Mouse scrolling
set mouse=a

" Airline
set laststatus=2
let g:airline_theme='powerlineish'
let g:airline_enable_fugitive=1

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
  set guifont=Monaco:h15    " set fonts for gui vim
  "set guifont=Menlo:h15    " set fonts for gui vim
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
map <leader>2 :TagbarToggle<CR>
" Allow saving of files as sudo when I forgot to start vim using sudo.
command! WW :execute ':silent w !sudo tee % > /dev/null' | :edit!
"
" When using p, adjust indent to the current line
nmap p ]p
" Ctrl + S for save
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command! -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
inoremap <leader>s <c-o>:Update<CR>
nmap <leader>s <c-o>:Update<CR>
" Rake / Rake spec
map <leader>m :w<CR>:!rake<CR>
map <leader>t :w<CR>:!rake spec<CR>
inoremap <leader>m <c-o>:Update<CR> <c-o>:!rake<CR>
inoremap <leader>t <c-o>:w<CR> <c-o>:!rake spec<CR>

:nmap <silent> <leader>d <Plug>DashSearch

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" CtrlP - Open files in a new tab
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': [],
  \ 'AcceptSelection("t")': ['<c-t>', '<cr>', '<c-m>'],
  \ }

" YouCompleteMe enter completion
let g:ycm_key_list_previous_completion=['<Up>']
let g:ycm_key_list_next_completion=['<Down>']
let g:ycm_key_list_select_completion = ['<ENTER>']

