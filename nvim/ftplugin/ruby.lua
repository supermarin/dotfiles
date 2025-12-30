vim.keymap.set('i', '<C-l>', ' => ', { noremap = true })
vim.keymap.set('n', '<leader>r', ':w|:vs term://ruby %<cr>', { silent = true })
vim.keymap.set('i', '<C-k>', '<Esc>d0idef <Esc>pA():\n', { noremap = true }) -- define method on the fly
