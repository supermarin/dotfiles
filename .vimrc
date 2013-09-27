" Environment
set shell=/bin/bash
set t_Co=256
set encoding=utf-8
" Speed up pressing O after Esc. Changes the timeout of terminal escaping
set timeout timeoutlen=1000 ttimeoutlen=100
" Hooking with system clipboard
if has("clipboard") " If the feature is available
  set clipboard=unnamed " copy to the system clipboard
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
" Color schemes
Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Bundle 'w0ng/vim-hybrid'
" Essentials
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/syntastic'
Bundle 'rking/ag.vim'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
" almost never use this one.. potential to go away
Bundle 'Tagbar'
" autocompletion
Bundle 'Valloric/YouCompleteMe'
" Text editing enhancements
Bundle 'SirVer/ultisnips'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-surround'
Bundle 'Raimondi/delimitMate'
Bundle 'editorconfig/editorconfig-vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM APPEARANCE / BEHAVIOR CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Light / Dark color scheme from 7am to 7pm
let hour = strftime("%H")
if 7 <= hour && hour < 19
    colorscheme Tomorrow
else
    colorscheme hybrid
endif
" GVim
if has('gui_running')
  set guifont=Monaco:h15
  "set guifont=Menlo:h15
  "set guifont=Inconsolata:h1
  set transparency=5
  set guioptions=egmrt " hide the gui menubar
endif
"
set nocompatible
set nobackup
set nowritebackup
set noswapfile
" Highlight current line
set cursorline
" syntax
syntax on
filetype plugin indent on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
" Line numbers
set number
" Mouse scrolling
set mouse=a
" Airline
set laststatus=2
let g:airline_theme='powerlineish'
let g:airline_enable_fugitive=1
" Cursor / carret switching
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" Real time search and highlight
set incsearch
set hlsearch
set ignorecase smartcase
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC TEXT EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentations
set smartindent
set autoindent
set ts=4 sts=4 sw=4
set expandtab
set smarttab
" lang specific indentations
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2 " Ruby
au BufRead,BufNewFile *.podspec,Podfile set ft=ruby " CocoaPods and Podfiles
au BufRead,BufNewFile *.json set ai filetype=javascript " JSON
au BufRead,BufNewFile *.md set ft=markdown " Markdown
" Whitespace
set listchars=trail:·,tab:▸\ ,eol:¬
set list
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ','
map <leader>y "*y
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
" Auto centering (Gary would say SKETCHY)
nmap N Nzz
nmap n nzz
nmap G Gzz
nmap } }zz
nmap { {zz
" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
" Tagbar toggle (open methods and props list in a sidebar)
map <leader>2 :TagbarToggle<CR>
"
" Allow saving of files as sudo when I forgot to start vim using sudo.
command! WW \|:execute ':silent w !sudo tee % > /dev/null' | :edit!

" When using p, adjust indent to the current line
nmap p ]p
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command! -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nmap <leader>s <c-o>:Update<CR>
" Search a given pattern in Dash.app
:nmap <silent> <leader>d <Plug>DashSearch
" CtrlP - Open files in a new tab
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': [],
  \ 'AcceptSelection("t")': ['<c-t>', '<cr>', '<c-m>'],
  \ }



" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

