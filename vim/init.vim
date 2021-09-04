let mapleader=" "
set cc=80
set clipboard=unnamedplus
set completeopt=menuone,noinsert,noselect
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
color gruvbox

" completion config
let g:completion_enable_snippet = "vim-vsnip"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_smart_case = 1

" gruvbox use hard contrast for readability
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

" Mappings
nnoremap <leader>h :nohlsearch<cr>
nnoremap <leader>p :Telescope find_files<cr>
nnoremap <leader>g :Telescope live_grep<cr>
nnoremap <leader>b :Telescope buffers<cr>
nnoremap gh ^
nnoremap gl $
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Unfuck paste when visual selecting
vnoremap p "_dP

augroup YO_OY
  autocmd!
  au BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
  autocmd BufWritePost luainit.lua PackerCompile
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua <<EOF
require("luainit")
EOF
