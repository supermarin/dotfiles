{ config, pkgs, ... }:
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
    firefox
    fzf
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
    calcurse # calendar
    calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022
    fractal # matrix. Unsupported on aarch64-darwin as of Aug 10 2022 (libhandy)
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    tdesktop # telegram
    thunderbird
    vdirsyncer # sync contacts & calendars
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
  ];

  programs.kitty = {
    enable = true;
    theme = "Ir Black";
    font = {
      name = "Fira Code";
      size = 15;
    };
  };

  services = mkIf isLinux (import ./home-services.nix pkgs).services;
  systemd = mkIf isLinux (import ./home-services.nix pkgs).systemd;
  programs.fish = import ./fish/fish.nix pkgs;
  programs.git = import ./git.nix pkgs;
  programs.neovim = import ./neovim.nix pkgs;
  home.file.".sqliterc".text = builtins.readFile ./sqliterc;
  home.file.".ssh/config".text = builtins.readFile ./ssh/config;
  xdg.configFile."i3status-rust/config.toml".text =
    builtins.readFile ./linux/sway/i3status-rs/config.toml;
  xdg.configFile."nvim/init.lua".text = builtins.readFile ./vim/init.lua;
  xdg.configFile."rg/config".text = builtins.readFile ./rg/config;
  xdg.configFile."sway/config".text = builtins.readFile ./linux/sway/config;
  xdg.configFile."tig/config".text = builtins.readFile ./tig/config;
  xdg.configFile."vdirsyncer/config".text = builtins.readFile ./vdirsyncer/config;
}
