vim.g.mapleader = ' '
vim.keymap.set('n', 'gh', '^', { desc = "kakoune: move to beginning of line" })
vim.keymap.set('n', 'gl', '$', { desc = "kakoune: move to end of line" })
vim.keymap.set('n', 'dp', 'd}', { desc = "delete to end of paragraph" })
vim.keymap.set('n', 'dP', 'd{', { desc = "delete to beginning of paragraph" })
vim.keymap.set('n', '<Esc>', ':noh<cr>', { desc = "remove highlight with Esc in normal" })
vim.keymap.set('v', 'p', '"_dP', { desc = "unfuck paste in visual mode" })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = "escape in terminal" })
vim.keymap.set('n', "J", "mzJ`z", { desc = "preserve cursor pos when joining lines" })
vim.keymap.set('n', '<c-j>', ':m +1<cr>==', { desc = "move line down, keep indent" })
vim.keymap.set('n', '<c-k>', ':m -2<cr>==', { desc = "move line up, keep indent" })
vim.keymap.set('v', '<c-j>', ":m '>+1<cr>gv=gv", { desc = "move visual up, keep indent" })
vim.keymap.set('v', '<c-k>', ":m '<-2<cr>gv=gv", { desc = "move visual down, keep indent" })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "center after going down" })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "center after going up" })
vim.keymap.set('n', '<leader>s', ':w<cr>', { desc = "save file" })
vim.keymap.set('n', '<leader>q', ':q<cr>', { desc = "close pane/window/vim" })
vim.keymap.set('n', '<leader>a', ':%y<cr>', { desc = "select & yank all" })
vim.keymap.set('n', '<c-h>', '<c-w>h', { desc = "window: select left pane" })
vim.keymap.set('n', '<c-l>', '<c-w>l', { desc = "window: select right pane" })
vim.keymap.set('n', '<tab>', 'gt', { desc = "switch between tabs in normal mode" })
vim.keymap.set('n', '<S-tab>', 'gT', { desc = "switch between tabs in normal mode" })

local tabspaces = 2
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
vim.opt.undofile = true
vim.opt.guifont = "Iosevka:h12"
vim.cmd.colorscheme("catppuccin")

vim.api.nvim_create_user_command('Wq', 'wq', {}) -- halp
vim.api.nvim_create_user_command('WQ', 'wq', {}) -- halp
vim.api.nvim_create_user_command('Q', 'q', {})   -- halp
vim.api.nvim_create_user_command('W', 'w', {})   -- halp

-- Fuzzy
vim.keymap.set('n', '<leader>p', ':FzfLua commands<cr>')
vim.keymap.set('n', '<leader>/', ':FzfLua live_grep<cr>')
vim.keymap.set('n', '<leader>f', ':FzfLua files<cr>')
vim.keymap.set('n', '<leader>b', ':FzfLua buffers<cr>')
vim.keymap.set('n', '<leader>h', ':FzfLua help_tags<cr>')

-- AUTOGROUPS / EVENTS
local au = vim.api.nvim_create_augroup('YO_OY', { clear = true })
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
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
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

-- TreeSitter
require("nvim-treesitter-textobjects").setup {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V',  -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
  },
}

function textobj()

end

vim.keymap.set({ "x", "o" }, "af", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end, { desc = "select a function" })
vim.keymap.set({ "x", "o" }, "if", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
end)



-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
local servers = { 'basedpyright', 'clangd', 'gopls', 'gleam', 'harper', 'lua_ls', 'nixd', 'r_language_server', 'ruby_lsp',
  'ruff', 'zls' }
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
}

local server_settings = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      }
    }
  },
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
      }
    }
  },
  ruff = {
    -- init_options = {
    --   settings = {
    --     -- Ruff language server settings go here
    --   }
    -- }
  },
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          -- diagnosticMode = "openFilesOnly",

          ignore = { '*' },
          inlayHints = {
            callArgumentNames = true
          }
        }
      }
    }
  },
  pyright = {
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { '*' },
          diagnosticMode = "workspace",
        },
      },
    },
  },
}

for _, server in ipairs(servers) do
  local server_opts = vim.tbl_deep_extend(
    "force",
    options,
    server_settings[server] or {}
  )
  vim.lsp.config(server, server_opts)
  vim.lsp.enable(server)
end


require('blink.cmp').setup({
  sources = {
    default = { 'lsp', 'snippets', 'buffer' },
  },
  signature = { enabled = true, }, -- [C-k] to toggle in insert
})

vim.diagnostic.config({ virtual_text = true, })

-------------------------------------------------------------------------------
-- Tests
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>tt", ":wa|:TestNearest<CR>")
vim.keymap.set("n", "<leader>ta", ":wa|:TestFile<CR>")
vim.keymap.set("n", "<leader>ts", ":wa|:TestSuite<CR>")
vim.keymap.set("n", "<leader>tl", ":wa|:TestLast<CR>")
vim.keymap.set("n", "<leader>tg", ":wa|:TestVisit<CR>")
