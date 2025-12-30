{
  config,
  pkgs,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  ln = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${file}";
in
{
  imports = [
    ./git/config.nix
    ./neovim.nix
    ./shells.nix
  ];

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = "$HOME/.config/rg/config"; # TODO: XDG_CONFIG_HOME
    AGE_RECIPIENTS_FILE = ./age/recipients.txt;
    MANPAGER = "nvim +Man!";
    TMUX_TMPDIR = ''''${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}''; # need if we install tmux manually and not thru home-manager
  };
  home.sessionPath = [ "${dotfiles}/functions" ];
  home.packages = with pkgs; [
    age
    age-plugin-yubikey
    bat # used in `e` for live preview of files
    btop
    claude-code
    coreutils # used for `shred`
    diffr # used in git stuff
    difftastic # testing this out
    dua # disk usage analyzer, better du -hc
    duckdb
    dysk # disk usage analyzer, better df -h
    helix
    eza # ls with stuff
    fd
    fzf
    git-lfs
    gnumake # why is this here? no idea
    jq
    jujutsu
    lazyjj
    mergiraf # experimental: git conflict resolver
    nixd # nix language server
    nixfmt-rfc-style # official nix formatter used by nixd
    nushell
    oath-toolkit # used for OTP
    ripgrep
    ripgrep-all
    rsync
    sqlite-interactive
    lua-language-server
    tig
    tmux-mem-cpu-load
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.file = {
    ".digrc".text = "+noall +answer";
    ".gnupg/gpg-agent.conf".text = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry";
    ".ssh/config".source = ln "ssh/config";
    ".sqliterc".source = ./sqliterc;
  };
  xdg.configFile = {
    "jj/config.toml".source = ln "jj/config.toml";
    "tig/config".source = ln "tig/config";
    "rg/config".source = ./rg/config;
  };
}
