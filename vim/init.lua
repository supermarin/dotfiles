vim.g.mapleader = ' '
vim.keymap.set('n', 'gh', '^')                   -- kakoune: move to beginning of line
vim.keymap.set('n', 'gl', '$')                   -- kakoune: move to end of line
vim.keymap.set('n', 'dp', 'd}')                  -- delete to end of paragraph
vim.keymap.set('n', 'dP', 'd{')                  -- delete to beginning of paragraph
vim.keymap.set('n', '<Esc>', ':noh<cr>')         -- remove highlight with Esc in normal
vim.keymap.set('v', 'p', '"_dP')                 -- Unfuck paste in visual mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')      -- Escape in terminal
vim.keymap.set('n', "J", "mzJ`z")                -- Preserve cursor pos when joining lines
vim.keymap.set('n', '<c-j>', ':m +1<cr>==')      -- move line down, keep indent
vim.keymap.set('n', '<c-k>', ':m -2<cr>==')      -- move line up, keep indent
vim.keymap.set('v', '<c-j>', ":m '>+1<cr>gv=gv") -- move visual up, keep indent
vim.keymap.set('v', '<c-k>', ":m '<-2<cr>gv=gv") -- move visual down, keep indent
vim.keymap.set('n', '<C-d>', '<C-d>zz')          -- center after going down
vim.keymap.set('n', '<C-u>', '<C-u>zz')          -- center after going up
vim.keymap.set('n', '<leader>s', ':w<cr>')       -- save file
vim.keymap.set('n', '<leader>q', ':q<cr>')       -- close pane/window/vim
vim.keymap.set('n', '<c-h>', '<c-w>h')           -- window: select left pane
vim.keymap.set('n', '<c-l>', '<c-w>l')           -- window: select right pane
vim.keymap.set('n', '<tab>', 'gt')               -- switch between tabs in normal mode
vim.keymap.set('n', '<S-tab>', 'gT')             -- switch between tabs in normal mode
vim.api.nvim_create_user_command('WQ', 'wq', {}) -- halp
vim.api.nvim_create_user_command('Wq', 'wq', {}) -- halp
vim.api.nvim_create_user_command('Q', 'q', {})   -- halp
vim.api.nvim_create_user_command('W', 'w', {})   -- halp
-- Telescope
vim.keymap.set('n', '<leader>c', ':Telescope commands<cr>')
vim.keymap.set('n', '<leader>/', ':Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>f', ':Telescope find_files<cr>')
vim.keymap.set('n', '<leader>b', ':Telescope buffers<cr>')

local tabspaces = 2
vim.opt.background = 'dark'
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = "80"
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.expandtab = true
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.guicursor = ""
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scroll = 8    -- scroll amount with C-D C-U
vim.opt.scrolloff = 8 -- top/bottom margins for scrolling
vim.opt.shiftwidth = tabspaces
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = tabspaces
vim.opt.termguicolors = true
vim.opt.undofile = true

-- AUTOGROUPS / EVENTS
local au = vim.api.nvim_create_augroup('YO_OY', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = au,
  pattern = { '*.py', },
  callback = function()
    vim.wo.colorcolumn = "88"
    vim.keymap.set('n', '<leader>r', ':w|:!python %<cr>', { silent = true })
  end,
})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = au,
  pattern = { '*.go', '*.lua', '*.nix', '*.rb', '*.py', },
  callback = function()
    vim.lsp.buf.format(nil, 1000) -- async can't quit vim if files are changed
  end,
})
vim.api.nvim_create_autocmd('BufReadPost', { -- save last postition in file
  group = au,
  pattern = '*',
  command = [[
     if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") >= 1 && line("'\"") <= line("$") |
       exe "normal! g`\"" |
     endif
   ]],
})
vim.api.nvim_create_autocmd('TermOpen', {
  group = au,
  pattern = { '*' },
  callback = function(opts)
    if opts.file:match('dap%-terminal') then
      return
    end
    vim.cmd('startinsert')
    vim.cmd('setlocal nonu')
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-------------------------------------------------------------------------------
-- Snippets
-------------------------------------------------------------------------------
local luasnip = require("luasnip")

-- LSP
--
local lspkind = require("lspkind")
local cmp = require("cmp")
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  experimental = {
    ghost_text = { enabled = true },
  },
  view = {
    entries = 'native'
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = {
    { name = 'codecompanion' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
  formatting = {
    format = lspkind.cmp_format {
      mode = "symbol_text",
      with_text = true,
      menu = {
        nvim_lsp = "[LSP]",
        cody = "[cody]",
      },
    },
  },
  mapping = {
    ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
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

-- Git Gutter
require('gitsigns').setup()

-- Set the highlight for removed lines to have a red background
vim.cmd [[
  highlight DiffDelete guibg=DarkRed
]]

-- Autopairs
require("nvim-autopairs").setup()
-- Key bindings explanation
require('which-key').setup { timeoutlen = 0 }
-- tree-sitter
require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
}
-- comment
require('Comment').setup()


-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- LSP go to - the only exception for LSP namespace.
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { silent = true })
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { silent = true })
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { silent = true })
  -- LSP namespace
  vim.keymap.set('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<cr>', { silent = true })
  vim.keymap.set('n', '<leader>h', '<cmd>lua vim.lsp.buf.hover()<cr>', { silent = true })
  vim.keymap.set('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { silent = true })
  vim.keymap.set('n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<cr>', { silent = true })
  vim.keymap.set('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', { silent = true })
  vim.keymap.set('n', '<leader>ea', '<cmd>lua vim.diagnostic.setloclist()<cr>', { silent = true })
  vim.keymap.set('n', '<leader>en', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { silent = true })
  vim.keymap.set('n', '<leader>ep', '<cmd>lua vim.diagnostic.goto_next()<cr>', { silent = true })
end


-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp = require('lspconfig')
-- TODO: should this attach per filetype?
local servers = { 'gopls', 'lua_ls', 'ruby_lsp', 'clangd', 'pylsp', 'r_language_server', 'nixd' }
local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    pylsp = {
      configurationSources = { 'pyproject' },
      plugins = {
        pycodestyle = { enabled = false },
        ruff = {
          -- enabled = true,
          -- formatEnabled = true,
          -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
          -- lineLength = 88, -- Line length to pass to ruff checking and formatting
        },
      }
    },
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

for _, server in ipairs(servers) do
  lsp[server].setup(options)
end



-------------------------------------------------------------------------------
-- AI
-------------------------------------------------------------------------------

require("codecompanion").setup {}
vim.keymap.set("n", "<leader>c", ":CodeCompanionChat<CR>")

-------------------------------------------------------------------------------
-- Tests
-------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>tt", ":wa|:TestNearest<CR>")
vim.keymap.set("n", "<leader>ta", ":wa|:TestFile<CR>")
vim.keymap.set("n", "<leader>ts", ":wa|:TestSuite<CR>")
vim.keymap.set("n", "<leader>tl", ":wa|:TestLast<CR>")
vim.keymap.set("n", "<leader>tg", ":wa|:TestVisit<CR>")
-------------------------------------------------------------------------------
-- DAP
-------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>dc", function() require('dap').continue() end, { desc = "Continue debug session" })
vim.keymap.set("n", "<leader>db", function() require('dap').toggle_breakpoint() end,
  { desc = "debug: Toggle breakpoint" })
vim.keymap.set("n", "<leader>dn", function() require('dap').step_over() end, { desc = "debug: Next" })
vim.keymap.set("n", "<leader>di", function() require('dap').step_into() end, { desc = "debug: Step Into" })
vim.keymap.set("n", "<leader>do", function() require('dap').step_out() end, { desc = "debug: Step Out" })
vim.keymap.set("n", "<leader>dr", function() require('dap').repl.toggle() end, { desc = "debug: Toggle REPL" })
vim.keymap.set("n", "<leader>du", function() require('dapui').toggle() end, { desc = "debug: Toggle UI" })

-- TODO: see if something like neotest would be beneficial to
-- 1. configure test runners with same keymaps for all langs
-- 2. configure test debugging for all
vim.keymap.set("n", "<leader>dt", function() require('dap-python').test_method() end, { desc = "debug: Test Method" })
vim.keymap.set("n", "<leader>dT", function() require('dap-python').test_class() end, { desc = "debug: Test Class" })

-- TODO: implement more debugging commands like execption breakpoints
-- from :help dap-configuration
-- set_exception_breakpoints({filters}, {exceptionOptions})
--                                               *dap.set_exception_breakpoints()*
--
--     Sets breakpoints on exceptions filtered by `filters`. If `filters` is not
--     provided it will prompt the user to choose from the available filters of the
--     debug adapter.
--
--     Parameters: ~
--         {filters}          A list of exception types to stop on (optional).
--                            Most debug adapters offer categories like `"uncaught"` and
--                            `"raised"` to filter the exceptions.
--                            If set to "default" instead of a table, the
--                            default options as recommended by the debug adapter are
--                            used.
--         {exceptionOptions} ExceptionOptions[]?
--                            (https://microsoft.github.io/debug-adapter-protocol/specification#Types_ExceptionOptions)
--
--     >lua
--         -- Ask user to stop on which kinds of exceptions
--         require'dap'.set_exception_breakpoints()
--         -- don't stop on exceptions
--         require'dap'.set_exception_breakpoints({})
--         -- stop only on certain exceptions (debugpy offers "raised", "uncaught")
--         require'dap'.set_exception_breakpoints({"uncaughted"})
--         require'dap'.set_exception_breakpoints({"raised", "uncaught"})
--         -- use default settings of debug adapter
--         require'dap'.set_exception_breakpoints("default")
-- <
--
--     You can also set the default value via a `defaults.fallback` table:
--
-- >lua
--         require('dap').defaults.fallback.exception_breakpoints = {'raised'}
-- <
--
--     Or per config/adapter type:
--
-- >lua
--         require('dap').defaults.python.exception_breakpoints = {'raised'}
-- <
--
--     In this example `python` is the type. This is the same type used in
--     |dap-configuration| or the |dap-adapter| definition.



-- require('nvim-dap-virtual-text').setup()
require('dap-python').setup("uv")
require('dapui').setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

if vim.g.neovide then
  vim.o.guifont = "Iosevka:h12"
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0
end
