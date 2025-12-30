{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    package = inputs.neovim-nightly.packages.${pkgs.system}.default;
    plugins = with pkgs.vimPlugins; [
      # Core editor functionality
      blink-cmp
      editorconfig-nvim
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
  };
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
}
