pkgs:
{
  enable = true;
  plugins = with pkgs.vimPlugins; [
    editorconfig-vim
    fzf-vim
    fzfWrapper
    gruvbox
    vim-commentary
    vim-fish
    vim-gitgutter
    vim-nix
    vim-repeat
    vim-surround
    vim-visual-multi
  ];
  extraConfig = ''
    let mapleader=" "
    set clipboard=unnamed
    set grepprg=rg\ --vimgrep
    set ignorecase
    set mouse=a
    set smartcase
    set smartindent
    set splitbelow
    set splitright
    set ts=2 sw=2 expandtab
    set undofile
    call mkdir($HOME."/.vim/undo", "p", 0700)
    set undodir=~/.vim/undo

    color gruvbox
    set termguicolors
    set background=dark
    set t_ut=

    nnoremap gh ^
    nnoremap gl $
    nnoremap <leader>p :GitFiles<cr>
    nnoremap <leader>b :Buffers<cr>
    nnoremap <leader>f :FZF<cr>

    au CursorHold,CursorHoldI * checktime
  '';
}
