{
  inputs,
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
    AGE_RECIPIENTS_FILE = ln "age/recipients.txt";
    MANPAGER = "nvim +Man!";
    TMUX_TMPDIR = ''''${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}''; # need if we install tmux manually and not thru home-manager
  };
  home.sessionPath = [ "${dotfiles}/functions" ];
  home.packages = with pkgs; [
    age
    age-plugin-tpm
    age-plugin-yubikey
    bashd
    bat # used in `e` for live preview of files
    btop
    coreutils # used for `shred`
    devenv # TODO: remove if I don't fully switch to it
    diffr # used in git stuff
    dua # disk usage analyzer, better du -hc
    duckdb
    dysk # disk usage analyzer, better df -h
    eza # ls with stuff
    fd
    fzf
    git-lfs
    gnumake # why is this here? no idea
    harper # english lang server
    helix
    jjui # jujutsu tui. using for interactively splitting
    jq
    jujutsu
    lua-language-server
    mergiraf # experimental: git conflict resolver
    nixd # nix language server
    nixfmt # official nix formatter used by nixd
    nushell
    oath-toolkit # used for OTP
    opencode
    restic
    ripgrep
    ripgrep-all
    rsync
    sqlite-interactive
    sops
    superhtml # HTML lsp server
    tig
    tmux
    tmux-mem-cpu-load
    wayvnc # connect to this machine via vnc
    zig
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.file = {
    ".digrc".text = "+noall +answer";
    ".ssh/config".source = ln "ssh/config";
    ".sqliterc".source = ./sqliterc;
    "code/.stignore".source = ./.stignore_global;
  };
  xdg.configFile = {
    "tmux/tmux.conf".source = ln "tmux/tmux.conf";
    "jj/config.toml".source = ln "jj/config.toml";
    "tig/config".source = ln "tig/config";
    "rg/config".source = ./rg/config;
    "containers/containers.conf".text = "[engine]\ndetach_keys='ctrl-x,ctrl-p'\n";
  };
}
