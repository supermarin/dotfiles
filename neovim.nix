{
  pkgs,
  config,
  ...
}:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Core editor functionality
      blink-cmp
      nvim-lspconfig # TODO: remove when lspcofig is merged into neovim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      vim-repeat
      vim-surround
      vim-visual-multi
      # Fuzzy
      fzf-lua
      # Git
      gitsigns-nvim
      # Misc
      vim-test
      which-key-nvim
    ];
    sideloadInitLua = true;
    withPython3 = true;
    withRuby = true;
  };
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
}
