pkgs: {
  enable = true;
  vimAlias = true;
  viAlias = true;
  plugins = with pkgs.vimPlugins; [
    # Core editor functionality
    comment-nvim
    editorconfig-nvim
    nvim-autopairs
    vim-repeat
    vim-surround
    vim-visual-multi
    # Copilot
    copilot-lua
    copilot-cmp
    # Colorschemes
    catppuccin-nvim
    nightfox-nvim
    everforest
    gruvbox-nvim
    oxocarbon-nvim
    # Telescope
    telescope-nvim
    plenary-nvim
    # Git
    neogit
    diffview-nvim
    gitsigns-nvim
    vim-fugitive
    # Misc
    vim-test
    which-key-nvim
    # Snippets
    luasnip
    cmp_luasnip
    # Tree-sitter
    nvim-treesitter.withAllGrammars
    # DAP
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-dap-python
    # Completion
    nvim-cmp
    nvim-lspconfig
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
    cmp-nvim-lsp-signature-help
  ];
}
