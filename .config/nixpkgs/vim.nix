pkgs:
{
  enable = true;
  vimAlias = true;
  vimdiffAlias = true;
  viAlias = true;
  withPython3 = true;
  plugins = with pkgs.vimPlugins; [
    fzf-vim
    fzfWrapper
    gruvbox
    vim-commentary
    vim-repeat
    vim-surround
    vim-nix
  ];
  extraConfig = ''
    set ts=2 sw=2 expandtab
    set smartcase
    set ignorecase
    set smartindent
    set grepprg=rg\ --vimgrep
    set splitright
    set splitbelow
    set mouse=nv
    let mapleader=" "

    color gruvbox

    nnoremap gh ^
    nnoremap gl $
    nnoremap <leader>p :GitFiles<cr>
    nnoremap <leader>b :Buffers<cr>

    " experimental: neovim terminal
    tnoremap <Esc> <C-\><C-n>
    au CursorHold,CursorHoldI * checktime
  '';
}
