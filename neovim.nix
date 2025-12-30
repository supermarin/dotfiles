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
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    plugins = with pkgs.vimPlugins; [
      # Core editor functionality
      blink-cmp
      editorconfig-nvim
      nvim-lspconfig # TODO: remove when lspcofig is merged into neovim
      vim-repeat
      vim-surround
      vim-visual-multi
      # DAP
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-dap-python
      # AI
      codecompanion-nvim
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
