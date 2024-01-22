{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  dconf.settings = (import ./linux/gnome/dconf.nix { pkgs = pkgs; });
  home.sessionVariables = {
    EDITOR = "nvim";
    FUZZY = "fzf";
    MAILDIR = "$HOME/.mail";
    PASSWORD_STORE_DIR = "$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = "$HOME/.config/rg/config"; # TODO: XDG_CONFIG_HOME
    NIXOS_OZONE_WL = "1"; #https://discourse.nixos.org/t/partly-overriding-a-desktop-entry/20743/2
    AGE_RECIPIENTS_FILE = ./age/recipients.txt;
  };

  home.sessionPath = [
    "$HOME/dotfiles/functions"
  ];

  home.packages = with pkgs; [
    age
    age-plugin-yubikey
    bat # used in `e` for live preview of files
    cmake # emacs needs to compile vterm
    coreutils # used for `shred`
    diffr # used in git stuff
    direnv
    discord
    eza # ls with stuff
    fd
    firefox-bin
    fzf
    git-lfs
    gnumake
    helix
    btop
    jq
    khal
    nbstripout
    nodejs-slim_20 # for copilot
    nushell
    oathToolkit # used for OTP
    # obsidian TODO: return when https://github.com/NixOS/nixpkgs/issues/273611 is fixed
    ripgrep
    rnix-lsp
    rio # terminal, seems to work ok with Berkeley Mono
    slack # for robot weatlth
    sqlite-interactive
    sumneko-lua-language-server
    tig
    wormhole-william
    zig # why was this? for the compiler IIRC? TODO: delete if unused
    zulip
    zulip-term
  ]
  ++ lib.optionals isDarwin [ ]
  ++ lib.optionals isLinux [
    # calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022
    fractal # matrix. Unsupported on aarch64-darwin as of Aug 10 2022 (libhandy)
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    vdirsyncer # sync contacts & calendars
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
  ];

  programs.fish = import ./fish/fish.nix pkgs;
  programs.git = import ./git.nix pkgs;
  programs.neovim = import ./neovim.nix pkgs;
  home.file.".digrc".text = "+noall +answer";
  home.file.".sqliterc".source = ./sqliterc;
  home.file.".ssh/config".source = ./ssh/config;
  xdg.configFile."i3status-rust/config.toml".source =
    ./linux/sway/i3status-rs/config.toml;
  xdg.configFile."khal/config".source = ./khal/config;
  xdg.configFile."nvim/init.lua".source = ./vim/init.lua;
  xdg.configFile."rg/config".source = ./rg/config;
  xdg.configFile."sway/config".source = ./linux/sway/config;
  xdg.configFile."tig/config".source = ./tig/config;
  xdg.configFile."vdirsyncer/config".source = ./secrets/vdirsyncer.conf;
  # Hacks / check temporarily if issues get fixed and remove
  # This is here because of https://github.com/FiloSottile/yubikey-agent/issues/92
  home.file.".gnupg/gpg-agent.conf".text = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry";
}
