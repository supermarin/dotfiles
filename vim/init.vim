" leader key
let mapleader=" "
" gruvbox use hard contrast for readability
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

set cc=80
set clipboard=unnamedplus
set completeopt=menu,menuone,noselect
set expandtab
set grepprg=rg\ --vimgrep
set guicursor=
set hidden
set ignorecase
set laststatus=2
set mouse=a
set noswapfile
set scrolloff=8
set smartcase
set smartindent
set smartindent
set splitbelow
set splitright
set ts=2 sw=2 expandtab
set undofile
set termguicolors
set background=dark
" color supermarin
color gruvbox

" Mappings
" TODO: move this into separate mappings lua?
nnoremap gh ^
nnoremap gl $
nnoremap <cr> :noh<cr>
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Unfuck paste when visual selecting
vnoremap p "_dP

augroup YO_OY
  autocmd!
  " Automatically format Go files with LSP
  au BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
  " TODO: Automatically format nix files with LSP
  "
  "  Restore cursor position on vim relaunch
  "  TODO: check if it's not git committing
  au BufReadPost *
    \ if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

lua <<EOF
require("luainit")
EOF
