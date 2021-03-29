local o = vim.o
local bo = vim.bo
local map = vim.api.nvim_set_keymap
local shareDir = vim.fn.stdpath('data')

bo.expandtab = true
bo.smartindent = true
bo.sw = 2
bo.ts = 2
bo.swapfile = false
o.clipboard = 'unnamed'
o.completeopt = "menuone,noselect"
o.grepprg = 'rg --vimgrep'
o.ignorecase = true
o.laststatus = 2
o.mouse = 'a'
o.scrolloff = 8
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.undodir = shareDir..'/undo'
o.undofile = true
vim.wo.cc = "80"
vim.cmd 'color gruvbox'

-- Mappings
vim.g.mapleader = ' '
local mapopts = { noremap = true }
map('n', '<leader>h', ':nohlsearch<cr>', mapopts)
map('n', 'gh', '^', mapopts)
map('n', 'gl', '$', mapopts)
map('n', '<leader>p', ':Telescope find_files<cr>', mapopts)
map('n', '<leader>g', ':Telescope live_grep<cr>', mapopts)
map('n', '<leader>b', ':Telescope buffers<cr>', mapopts)
map('i', '<C-Space>', '<Plug>(completion_trigger)', { silent = true })
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

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
  map_buf('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', lsp_opts)
  map_buf('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<cr>', lsp_opts)
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

-- Plugins
-- Auto install packer.nvim if not exists
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
  use { 'morhetz/gruvbox' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }
  use { 'mg979/vim-visual-multi' }
end)

local lsp = require 'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.gopls.setup{on_attach=on_attach, capabilities=capabilities}
lsp.sumneko_lua.setup{on_attach=on_attach}

vim.cmd 'autocmd BufWritePost init.lua PackerCompile'
vim.cmd 'au BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)'

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
