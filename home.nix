# TODO: remove lib dep as soon as ~/Applications fiasco is out
{ config, pkgs, lib, ... }:
let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.stateVersion = "22.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    FUZZY = "fzf";
    MAILDIR = "$HOME/.mail";
    PASSWORD_STORE_DIR = "$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = "$HOME/.config/rg/config"; # TODO: XDG_CONFIG_HOME
  };

  home.sessionPath = [
    "$HOME/dotfiles/functions"
    "$HOME/go/bin"
  ];

  imports = [
    ./mail.nix
  ];

  home.packages = with pkgs; [
    age
    bat # used in `e` for live preview of files
    coreutils # used for `shred`
    diffr # used in git stuff
    docker-compose
    exa # ls with stuff
    fd
    fzf
    git
    gnupg
    helix
    htop
    jq
    nodejs # for github copilot only
    oathToolkit # used for OTP
    obsidian
    pass
    ripgrep
    rnix-lsp
    slack
    sqlite
    sumneko-lua-language-server
    tig
    wormhole-william
    zig
  ]
  ++ [
    # text editing (non-system) fonts
    go-font
    jetbrains-mono
  ]
  ++ lib.optionals isDarwin [ ]
  ++ lib.optionals isLinux [
    brave # https://github.com/NixOS/nixpkgs/pull/98853/files
    calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022
    fractal # matrix. Unsupported on aarch64-darwin as of Aug 10 2022 (libhandy)
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    tdesktop # telegram
    thunderbird
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Core editor functionality
      editorconfig-nvim
      nvim-autopairs
      vim-visual-multi
      # Colorschemes
      gruvbox-nvim
      # Telescope
      telescope-nvim
      plenary-nvim
      # Misc
      gitsigns-nvim
      vim-commentary
      vim-fugitive
      vim-repeat
      vim-surround
      vim-test
      which-key-nvim
      # Snippets
      luasnip
      cmp_luasnip
      friendly-snippets
      # Tree-sitter
      nvim-treesitter.withAllGrammars
      nvim-ts-rainbow
      # DAP
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      # Completion
      nvim-cmp
      nvim-lspconfig
      # Various nvim-cmp components
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp-signature-help
    ];
  };

  programs.kitty = {
    enable = true;
    theme = "Ir Black";
    font = {
      name = "JetBrains Mono";
      size = 15;
    };
  };

  services.syncthing = {
    enable = isLinux;
  };

  home.file.".sqliterc".text = builtins.readFile ./sqliterc;
  home.file.".ssh/config".text = builtins.readFile ./ssh/config;
  programs.fish = import ./fish/fish.nix pkgs;
  programs.git = import ./git.nix;
  xdg.configFile."i3status-rust/config.toml".text =
    builtins.readFile ./linux/sway/i3status-rs/config.toml;
  xdg.configFile."nvim/init.lua".text = builtins.readFile ./vim/init.lua;
  xdg.configFile."rg/config".text = builtins.readFile ./rg/config;
  xdg.configFile."sway/config".text = builtins.readFile ./linux/sway/config;
  xdg.configFile."tig/config".text = builtins.readFile ./tig/config;
}
