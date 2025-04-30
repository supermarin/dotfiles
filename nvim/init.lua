vim.g.mapleader = ' '
vim.keymap.set('n', 'gh', '^', { desc = "kakoune: move to beginning of line" })
vim.keymap.set('n', 'gl', '$', { desc = "kakoune: move to end of line" })
vim.keymap.set('n', 'dp', 'd}', { desc = "delete to end of paragraph" })
vim.keymap.set('n', 'dP', 'd{', { desc = "delete to beginning of paragraph" })
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
-- Telescope
vim.keymap.set('n', '<leader>c', ':Telescope commands<cr>')
vim.keymap.set('n', '<leader>/', ':Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>f', ':Telescope find_files<cr>')
vim.keymap.set('n', '<leader>b', ':Telescope buffers<cr>')
vim.keymap.set('n', '<leader>h', ':Telescope help_tags<cr>')

local tabspaces = 2
vim.opt.background = 'dark'
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = "80"
vim.opt.expandtab = true
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.hidden = true
vim.opt.ignorecase = true
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

vim.api.nvim_create_user_command('Wq', 'wq', {}) -- halp
vim.api.nvim_create_user_command('WQ', 'wq', {}) -- halp
vim.api.nvim_create_user_command('Q', 'q', {})   -- halp
vim.api.nvim_create_user_command('W', 'w', {})   -- halp

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
  pattern = '*',
  callback = function(opts)
    vim.opt.number = false
    vim.opt.relativenumber = false
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

-- Git Gutter
require('gitsigns').setup()

-- Key bindings explanation
require('which-key').setup { delay = 0, preset = 'helix' }

-- tree-sitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    disable = function(_, buf)        -- disable on big files
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  textobjects = {
    enable = true,
    select = {
      enable = true,
      -- include_surrounding_whitespace = true,
      -- lookahead = false,
      keymaps = {
        ["am"] = "@function.outer",
        ["im"] = "@function.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["il"] = "@loop.inner",
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
      },
    },
  },
}

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
local lspconfig = require('lspconfig')
local servers = { 'gopls', 'lua_ls', 'ruby_lsp', 'clangd', 'pylsp', 'r_language_server', 'nixd' }
local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { silent = true })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })

  if not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
      end,
    })
  end
end

local options = {
  on_attach = on_attach,
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    pylsp = {
      configurationSources = { 'pyproject' },
      plugins = {
        pycodestyle = { enabled = false },
      }
    },
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    },
  }
}

require('blink.cmp').setup({
  keymap = { preset = 'enter' },
  sources = {
    default = { 'lsp', 'snippets', 'codecompanion', 'buffer' },
  },
  -- signature = { enabled = true, }, -- [C-k] to toggle in insert
})

for _, server in ipairs(servers) do
  lspconfig[server].setup(options)
end


vim.diagnostic.config({ virtual_lines = true, })

-------------------------------------------------------------------------------
-- AI
-------------------------------------------------------------------------------

require("codecompanion").setup {
  adapters = {
    gemini = function()
      return require("codecompanion.adapters").extend("gemini", {
        env = {
          api_key = "AIzaSyBLpvRQ6LQnaDJEWFTt7gLY0xaF_V4e0fg",
        },
      })
    end,
  },
  strategies = {
    -- chat = { adapter = "anthropic" },
    chat = { adapter = "gemini" },
    inline = { adapter = "gemini" },
  },
}
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

-- The video uses an early version of the future 'minispring' dark color
require('mini.hues').setup({ background = '#122722', foreground = '#c2dbd3', accent = 'green' })
