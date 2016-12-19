set shell=$SHELL
scriptencoding utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

" Color schemes
Plug 'rakr/vim-one'

" Code Navigation
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'mileszs/ack.vim'

" Completion / linting
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'neomake/neomake'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Vim enhancements
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat' " Repeat plugin commands with '.'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'

" Text editing enhancements
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-multiple-cursors'
Plug 'valloric/MatchTagAlways'

" Lang specific bundles
Plug 'vim-ruby/vim-ruby',    { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }
Plug 'tpope/vim-cucumber',   { 'for': 'cucumber' }
Plug 'fatih/vim-go',         { 'for': 'go' }
Plug 'instant-markdown.vim', { 'for': 'markdown' }
Plug 'tpope/vim-liquid',     { 'for': 'liquid' }
Plug 'tpope/vim-jdaddy',     { 'for': 'json' }
Plug 'keith/swift.vim',      { 'for': 'swift' }
Plug 'zchee/deoplete-jedi',  { 'for': 'python'}
Plug 'vim-jp/vim-cpp',       { 'for': ['c', 'objc', 'c++', 'cpp'] }
Plug 'darfink/vim-plist',    { 'for': 'plist' }

" tmux
Plug 'christoomey/vim-tmux-navigator'

" stupid features
Plug 'junegunn/vim-github-dashboard'

call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nobackup
set nowritebackup
set noswapfile
" Highlight current line
set cursorline
" display incomplete commands
set showcmd
" syntax
syntax on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" Line numbers
set number

set ignorecase smartcase

" Enable search/replace preview in place
set inccommand=nosplit

" Persistent undo
set undolevels=2000
set undofile

" Start linting when file is opened
autocmd! BufWritePost,BufEnter * Neomake

" Source the vimrc file after saving it
augroup VIMRC_LIVE_RELOAD
    au!
    au bufwritepost .vimrc source $MYVIMRC
augroup end

" Default overrides - check with nvim and revisit!
set lazyredraw " Don't redraw vim in all situations
set autoread   " Watch for file changes and auto update
set autowrite  " Automatically write file before running :make

" Unfuck splits to position cursor on the right / below split. Thank you.
set splitbelow
set splitright

" Speed up pressing O after Esc. Changes the timeout of terminal escaping
set timeout timeoutlen=1000 ttimeoutlen=100

" Hooking with system clipboard
if has("clipboard") " If the feature is available
  set clipboard=unnamed " copy to the system clipboard
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM APPEARANCE / BEHAVIOR CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors
set termguicolors
set background=light
colorscheme one

" Cursor shape change
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Netrw width
let g:netrw_winsize = 25

" keep more context when scrolling off the end of a buffer
set scrolloff=10

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC TEXT EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentations
set smartindent
set ts=4 sts=4 sw=4
set expandtab

" lang specific indentations
au BufRead,BufNewFile *.podspec,Podfile set ft=ruby " CocoaPods and Podfiles
au BufRead,BufNewFile *.gradle,Jenkinsfile set ft=groovy " Android, Jerkins
au BufRead,BufNewFile *.json set ai filetype=javascript " JSON
au BufRead,BufNewFile *.md set ft=markdown " Markdown
au FileType make setlocal noexpandtab
au FileType ruby,groovy,haml,eruby,yaml,sass set ai sw=2 sts=2 et
au FileType html,javascript,python set sw=4 sts=4 et

au BufWritePre * :%s/\s\+$//e " Strip trailing spaces on save
set list " Whitespace chars
set listchars=tab:\·\ ,trail:·

" Rulers
set cc=80
au FileType swift set cc=110
au FileType objc  set cc=120

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin overrides
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack.vim
" todo: see if i can just use native grep instead of ack.vim
let g:ackprg = 'rg --vimgrep --no-heading --no-ignore --hidden --follow --glob "!./tags" --glob "!.git/*" --glob "!build/"'
cnoreabbrev ag Ack

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" Neomake
let g:neomake_error_sign   = {'text': 'E', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '>>', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '>', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign    = {'text': 'i', 'texthl': 'NeomakeInfoSign'}

" InstantMarkdownPreview
let g:instant_markdown_autostart = 0

" Vim-go
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
"let g:go_highlight_operators = 1

let g:go_highlight_build_constraints = 1

"Show a list of interfaces which is implemented by the type under your cursor with <leader>s
au FileType go nmap <Leader>i <Plug>(go-implements)

"Show type info for the word under your cursor with <leader>i
"(useful if you have disabled auto showing type info via g:go_auto_type_info)
au FileType go nmap <Leader>d <Plug>(go-info)

" Sometimes when using both vim-go and syntastic Vim will start lagging while
" saving and opening files. The following fixes this:
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']

" Nerdcomment
let g:NERDAltDelims_swift = 1

" Ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","

" Disable default git-gutter shit
let g:gitgutter_map_keys = 0

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Move around tabs with [ ]
nnoremap <M-}> gt
nnoremap <M-{> gT

" Better moving up-down for giantass wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Toggle comments
map <silent> <leader>/ :call NERDComment(0,"toggle")<C-m>

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Insert a hash rocket with <c-l>
au FileType ruby imap <c-l> <space>=><space>
au FileType go   imap <c-l> <space>:=<space>

" Clear the search buffer when hitting return
nnoremap <leader>h :nohlsearch<cr>

" Tagbar toggle (open methods and props list in a sidebar)
map <leader>2 :TagbarToggle<CR>

" When using p, adjust indent to the current line
nmap p ]p

" Turn on spell check for Markdown files
function! SpellCheck()
    setlocal spell spelllang=en_us
endfunction
au FileType md,markdown call SpellCheck()
nmap <leader>s :setlocal spell spelllang=en_us<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JSON
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! PrettyJson()
    :'<,'>!python -m json.tool
endfunction
vmap <leader>f :call PrettyJson()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <C-p> :FZF<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-SURROUND
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <leader># Surround a word with #{ruby interpolation}
map <leader># ysiw#
vmap <leader># c#{<C-R>"}<ESC>

" <leader>" Surround a word with "quotes"
map <leader>" ysiw"
vmap <leader>" c"<C-R>""<ESC>

" <leader>' Surround a word with 'single quotes'
map <leader>' ysiw'
vmap <leader>' c'<C-R>"'<ESC>

" <leader>) or <leader>( Surround a word with (parens)
" The difference is in whether a space is put in
map <leader>( ysiw(
map <leader>) ysiw)
vmap <leader>( c( <C-R>" )<ESC>
vmap <leader>) c(<C-R>")<ESC>

" <leader>[ Surround a word with [brackets]
map <leader>] ysiw]
map <leader>[ ysiw[
vmap <leader>[ c[ <C-R>" ]<ESC>
vmap <leader>] c[<C-R>"]<ESC>

" <leader>{ Surround a word with {braces}
map <leader>} ysiw}
map <leader>{ ysiw{
vmap <leader>} c{ <C-R>" }<ESC>
vmap <leader>{ c{<C-R>"}<ESC>
map <leader>` ysiw`

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILE EXPLORER
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle Vexplore with Leader-1
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <leader>1 :call ToggleVExplorer()<CR>

" Use tree-mode as default view
let g:netrw_liststyle=3
" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Compile and run
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au Filetype ruby        nmap <leader>r :w\|:te ruby %<cr>
au Filetype python      nmap <leader>r :w\|:te python %<cr>
au Filetype java        nmap <leader>r :w\|:te javac %<cr> :te java %:r<cr>
au Filetype swift       nmap <leader>r :w\|:te swift %<cr>
au Filetype sh,bash,zsh nmap <leader>r :w\|:te $SHELL %<cr>

" Golang... I'm shhhpeshial
au FileType go          nmap <leader>r <Plug>(go-run)
au FileType go          nmap <leader>b <Plug>(go-build)
au FileType go          nmap <leader>t <Plug>(go-test)
au FileType go          nmap <leader>c <Plug>(go-coverage-toggle)
au FileType go          nmap <leader>a :GoAlternate<CR>


" Definition in a split / vertical
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ruby - RUNNING TESTS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au Filetype ruby   map <Leader>t :w\|:call RunCurrentSpecFile()<CR>
au Filetype ruby   map <Leader>s :w\|:call RunNearestSpec()<CR>
au Filetype ruby   map <Leader>e :w\|:call RunLastSpec()<CR>
au Filetype ruby   map <Leader>a :w\|:call RunAllSpecs()<CR>

au Filetype cucumber map <leader>t :w\|:!cucumber %<cr>
