runtime! python_setup.vim

source ~/.vimrc

autocmd! BufWritePost,BufEnter * Neomake
"set termguicolors

" Hack to get C-h working in neovim
nmap <BS> <C-W>h
tnoremap <Esc> <C-\><C-n>


" Plugin overrides
let g:neomake_error_sign   = {'text': 'E', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '>>', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '>', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign    = {'text': 'i', 'texthl': 'NeomakeInfoSign'}
