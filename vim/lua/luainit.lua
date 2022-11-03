local shareDir = vim.fn.stdpath('data')
vim.o.undodir = shareDir..'/undo'

-- PLUGINS
local install_path = shareDir..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command(
    '!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd [[packadd packer.nvim]]
---

require('packer').startup(function()
  -- Core editor functionality
  use { 'wbthomason/packer.nvim', opt = true }
  use { 'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}
  }
  use { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  use { 'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        timeoutlen = 0
      }
    end
  }
  use 'gpanders/editorconfig.nvim'
  -- LSP, completion
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- snippets
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets' 
  -- Tree Sitter
  use 'nvim-treesitter/nvim-treesitter'
  use 'p00f/nvim-ts-rainbow' -- rainbow parentheses
  -- Debugger
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  -- Misc
  use 'LnL7/vim-nix'
  use 'mg979/vim-visual-multi'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  -- Color Schemes
  use 'ellisonleao/gruvbox.nvim'
  use 'ishan9299/modus-theme-vim'
  -- Tests
  use 'vim-test/vim-test'
end)


-- Completion & snippets

local luasnip = require("luasnip")
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args) require('luasnip').lsp_expand(args.body) end,
  },
  experimental = {
    ghost_text = true,
  },
  view = {
    entries = 'native'
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
  }, {
    { name = 'nvim_lsp_signature_help' },
  }, {
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  }),
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})

-- snippets
require("luasnip.loaders.from_vscode").load()

-- tree-sitter
require('nvim-treesitter.configs').setup { 
  -- ensure_installed = 'maintained',  
  highlight = {enable = true},
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  }
}



-------------------------------------------------------------------------------
-- Telescope
-------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>p',  ':Telescope commands<cr>')
vim.keymap.set('n', '<leader>f',  ':Telescope find_files<cr>')
vim.keymap.set('n', '<leader>g',  ':Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>b',  ':Telescope buffers<cr>')

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local lsp_opts = { noremap=true, silent=true }

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', lsp_opts)
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', lsp_opts)
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', lsp_opts)
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', lsp_opts)
  vim.keymap.set('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', lsp_opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', lsp_opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', lsp_opts)
  vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<cr>', lsp_opts)
  vim.keymap.set('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<cr>', lsp_opts)
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', lsp_opts)
  vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', lsp_opts)
  vim.keymap.set('n', '<leader>dd', '<cmd>lua vim.lsp.buf.document_diagnostics()<cr>', lsp_opts)
end


-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp = require('lspconfig')
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

-------------------------------------------------------------------------------
-- Tests
-------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>")
vim.keymap.set("n", "<leader>ta", ":TestFile<CR>")
vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>")
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>")
vim.keymap.set("n", "<leader>tg", ":TestVisit<CR>")
-------------------------------------------------------------------------------
-- DAP
-------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>dn", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>di", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<leader>do", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>du", ":lua require'dapui'.open()<CR>")

require('dapui').setup()
require('nvim-dap-virtual-text').setup()
local dap = require('dap')

dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = {'dap', '-l', '127.0.0.1:${port}'},
  }
}

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug file",
    request = "launch",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Test file",
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Debug project (go.mod)",
    request = "launch",
    mode = "launch",
    program = "./${relativeFileDirname}"
  },
  {
    type = "delve",
    name = "Test project (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  },
  {
    name = "Attach to process",
    type = 'delve',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
    request = 'attach',
    pid = require('dap.utils').pick_process,
    args = {},
  },
  {
    name = "Attach to process",
    type = 'delve',  -- Adjust this to match your adapter name (`dap.adapters.<name>`)
    request = 'attach',
    pid = require('dap.utils').pick_process,
    args = { 'pidof',  'aerc.debug', },
  },
}
