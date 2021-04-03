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

" Mappings
nnoremap <leader>h :nohlsearch<cr>
nnoremap <leader>p :Telescope find_files<cr>
nnoremap <leader>g :Telescope live_grep<cr>
nnoremap <leader>b :Telescope buffers<cr>
nnoremap gh ^
nnoremap gl $
inoremap <silent> <C-Space> <Plug>(completion_trigger)
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Unfuck paste when visual selecting
vnoremap p "_dP

lua <<EOF
local shareDir = vim.fn.stdpath('data')
vim.o.undodir = shareDir..'/undo'

-- PLUGINS
-- Auto install packer.nvim if not exists. Needs to be done first because
-- lua crashes while loading other options depending on plugins.
local install_path = shareDir..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command(
    '!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost init.lua PackerCompile'
require('packer').startup(function()
  use { 'wbthomason/packer.nvim', opt = true }
   -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim', requires = {
      {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}
  }}
  -- LSP, completion, tree-sitter
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-lua/completion-nvim' }
  use { 'nvim-treesitter/nvim-treesitter' }
  use { 'hrsh7th/nvim-compe' }
  use { 'hrsh7th/vim-vsnip-integ', requires = { 'hrsh7th/vim-vsnip' } }
  use { 'honza/vim-snippets' }
  -- Misc
  use { 'LnL7/vim-nix' }
  use { 'airblade/vim-gitgutter' }
  use { 'mg979/vim-visual-multi' }
  use { 'morhetz/gruvbox' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }
end)

-- LSP
local on_attach = function(client, bufnr)
  require('completion').on_attach()
  require('nvim-treesitter.configs').setup { 
    ensure_installed = 'go', 
    -- TODO: return this back once people support 0.19
    -- ensure_installed = 'maintained',  
    highlight = {enable = true}
  }

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local function map_buf(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local lsp_opts = { noremap=true, silent=true }

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  map_buf('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', lsp_opts)
  map_buf('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', lsp_opts)
  map_buf('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', lsp_opts)
  map_buf('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', lsp_opts)
  map_buf('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', lsp_opts)
  map_buf('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', lsp_opts)
  map_buf('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', lsp_opts)
  map_buf('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<cr>', lsp_opts)
  map_buf('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', lsp_opts)
  map_buf('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', lsp_opts)
  map_buf('n', '<leader>dd', '<cmd>lua vim.lsp.buf.document_diagnostics()<cr>', lsp_opts)
end

local lsp = require 'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.gopls.setup{on_attach=on_attach, capabilities=capabilities}
lsp.rnix.setup{on_attach=on_attach, capabilities=capabilities}
lsp.sourcekit.setup{on_attach=on_attach, capabilities=capabilities}

-- TODO: do we need to move this to an autogroup?
vim.cmd 'autocmd BufWritePost init.lua PackerCompile'
vim.cmd 'au BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)'

-- Completion
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}
EOF
