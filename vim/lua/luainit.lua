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
require('packer').startup(function()
  use { 'wbthomason/packer.nvim', opt = true }
   -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}
  }
  use { 'nvim-telescope/telescope-frecency.nvim',
    requires = {'tami5/sqlite.lua'},
    config = function()
      require'telescope'.load_extension('frecency')
    end
  }
  -- LSP, completion, tree-sitter
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'hrsh7th/vim-vsnip-integ'
  use 'hrsh7th/vim-vsnip'
  use "rafamadriz/friendly-snippets" 
  -- Misc
  use 'LnL7/vim-nix'
  use 'airblade/vim-gitgutter'
  use 'mg979/vim-visual-multi'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  -- Appearance
  use 'morhetz/gruvbox'
end)

-- LSP
local on_attach = function(client, bufnr)
  require('completion').on_attach()
  require('nvim-treesitter.configs').setup { 
    ensure_installed = 'maintained',  
    highlight = {enable = true}
  }

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local lsp_opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', lsp_opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', lsp_opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', lsp_opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', lsp_opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', lsp_opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', lsp_opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', lsp_opts)
  buf_set_keymap('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', lsp_opts)
  buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<cr>', lsp_opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', lsp_opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', lsp_opts)
  buf_set_keymap('n', '<leader>dd', '<cmd>lua vim.lsp.buf.document_diagnostics()<cr>', lsp_opts)
end

local lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "gopls", "rnix" }

for _, server in ipairs(servers) do
  lsp[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

lsp.sourcekit.setup{on_attach=on_attach, capabilities=capabilities, cmd={
  "docker",
  "run",
  "--rm",
  "-v",
  vim.loop.os_homedir() .. ":" .. vim.loop.os_homedir(),
  "swiftlang/swift:nightly",
  "sourcekit-lsp"
}}

