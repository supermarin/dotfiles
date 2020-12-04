local custom_lsp_attach = function(client)
  -- See `:help nvim_buf_set_keymap()` for more information
  vim.api.nvim_buf_set_keymap(0, 'n', 'K',
    '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>',
    '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})

  -- vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- For plugins with an `on_attach` callback, call them here. For example:
  require('completion').on_attach(client)
end

local custom_lua_example = {
  -- An example of settings for an LSP server.
  --    For more options, see nvim-lspconfig
  -- settings = {
  --   Lua = {
  --     diagnostics = {
  --       enable = true,
  --       globals = { "vim" },
  --     },
  --   }
  -- },

  on_attach = custom_lsp_attach
}

require('lspconfig').sumneko_lua.setup(custom_lua_example)
require('lspconfig').rnix.setup({
  on_attach = custom_lsp_attach
})
