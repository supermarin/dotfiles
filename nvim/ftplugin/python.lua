vim.wo.colorcolumn = "88"
vim.keymap.set('n', '<leader>r', ':w|:vs term://python %<cr>', { silent = true })
-- vim.keymap.set('i', '<C-k>', '<Esc>d0idef <Esc>pA():\n', { noremap = true }) -- define method on the fly
