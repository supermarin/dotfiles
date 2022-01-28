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
color modus-vivendi

" Mappings
" TODO: move this into separate mappings lua?
nnoremap <leader>p :Telescope frecency<cr>
nnoremap <leader>f :Telescope find_files<cr>
nnoremap <leader>g :Telescope live_grep<cr>
nnoremap <leader>b :Telescope buffers<cr>
nnoremap gh ^
nnoremap gl $
nnoremap <cr> :noh<cr>
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Unfuck paste when visual selecting
vnoremap p "_dP

augroup YO_OY
  autocmd!
  au BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END

lua <<EOF
require("luainit")
EOF
