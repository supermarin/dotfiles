pkgs:
{
  enable = true;
  vimAlias = true;
  vimdiffAlias = true;
  viAlias = true;
  withPython3 = true;
  package = pkgs.neovim-nightly;
  plugins = with pkgs.vimPlugins; [
    editorconfig-vim
    fzf-vim
    fzfWrapper
    gruvbox
    vim-commentary
    vim-fish
    vim-nix
    vim-repeat
    vim-surround
  ];
  extraConfig = ''
    let mapleader=" "
    set clipboard=unnamedplus
    set grepprg=rg\ --vimgrep
    set ignorecase
    set mouse=a
    set smartcase
    set smartindent
    set splitbelow
    set splitright
    set ts=2 sw=2 expandtab

    color gruvbox

    nnoremap gh ^
    nnoremap gl $
    nnoremap <leader>p :GitFiles<cr>
    nnoremap <leader>b :Buffers<cr>
    nnoremap <leader>f :FZF<cr>

    " experimental: neovim terminal
    tnoremap <c-w> <C-\><C-n><c-w>
    tnoremap <Esc> <C-\><C-n>
    au CursorHold,CursorHoldI * checktime
  '';
}
