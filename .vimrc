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
" Code Navigation
"Bundle 'kien/ctrlp.vim'
Bundle 'rking/ag.vim'
" autocompletion / snippets
Bundle 'Valloric/YouCompleteMe'
Bundle 'SirVer/ultisnips'
" Vim enhancements
Bundle 'Tagbar'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/syntastic'
" Text editing enhancements
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-surround'
Bundle 'Raimondi/delimitMate'
Bundle 'editorconfig/editorconfig-vim'
" Lang specific bundles
Bundle 'vim-ruby/vim-ruby'
Bundle 'dag/vim-fish'
Bundle 'tpope/vim-cucumber'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM APPEARANCE / BEHAVIOR CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Light / Dark color scheme from 7am to 7pm
"let hour = strftime("%H")
"if 7 <= hour && hour < 19
    "colorscheme Tomorrow
"else
    colorscheme hybrid
"endif
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
" keep more context when scrolling off the end of a buffer
set scrolloff=10
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
au BufRead,BufNewFile *.podspec,Podfile set ft=ruby " CocoaPods and Podfiles
au BufRead,BufNewFile *.json set ai filetype=javascript " JSON
au BufRead,BufNewFile *.md set ft=markdown " Markdown
autocmd FileType make setlocal noexpandtab
autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
autocmd FileType python set sw=4 sts=4 et
" Whitespace
set listchars=trail:·,tab:\ \ 
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

" Clear the search buffer when hitting return
function! RemoveHighlights()
  nnoremap <leader>h :nohlsearch<cr>
endfunction
call RemoveHighlights()

" Select all
function! SelectAll()
  nnoremap <leader>a gg\|VG
endfunction
call SelectAll()

" Tagbar toggle (open methods and props list in a sidebar)
map <leader>2 :TagbarToggle<CR>

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
"let g:ctrlp_prompt_mappings = {
  "\ 'AcceptSelection("e")': [],
  "\ 'AcceptSelection("t")': ['<c-t>', '<cr>', '<c-m>'],
  "\ }

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EXPERIMENTAL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ultisnips hack
function! g:UltiSnips_Complete()
call UltiSnips_ExpandSnippet()
if g:ulti_expand_res == 0
    if pumvisible()
        return "\<C-n>"
    else
        call UltiSnips_JumpForwards()
        if g:ulti_jump_forwards_res == 0
           return "\<TAB>"
        endif
    endif
endif
return ""
endfunction

au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-e>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SELECTA
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    silent let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaCommand("find * -type f", "", ":e")<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"function! OpenTestAlternate()
  "let new_file = AlternateForCurrentFile()
  "exec ':e ' . new_file
"endfunction
"function! AlternateForCurrentFile()
  "let current_file = expand("%")
  "let new_file = current_file
  "let in_spec = match(current_file, '^spec/') != -1
  "let going_to_spec = !in_spec
  "let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  "if going_to_spec
    "if in_app
      "let new_file = substitute(new_file, '^app/', '', '')
    "end
    "let new_file = substitute(new_file, '\.e\?rb$', '_spec.rb', '')
    "let new_file = 'spec/' . new_file
  "else
    "let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    "let new_file = substitute(new_file, '^spec/', '', '')
    "if in_app
      "let new_file = 'app/' . new_file
    "end
  "endif
  "return new_file
"endfunction
"nnoremap <leader>. :call OpenTestAlternate()<cr>

