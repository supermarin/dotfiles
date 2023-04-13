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
    coreutils # used for `shred`
    diffr # used in git stuff
    exa # ls with stuff
    fd
    firefox-bin
    fzf
    gnupg
    htop
    jq
    khal-nightly
    oathToolkit # used for OTP
    obsidian
    pass
    ripgrep
    rnix-lsp
    slack
    sqlite-interactive
    sumneko-lua-language-server
    tig
    wormhole-william
    zig # why was this? for the compiler IIRC? TODO: delete if unused
  ]
  ++ [
    # text editing (non-system) fonts
    jetbrains-mono
  ]
  ++ lib.optionals isDarwin [ ]
  ++ lib.optionals isLinux [
    brave # https://github.com/NixOS/nixpkgs/pull/98853/files
    # calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022
    fractal # matrix. Unsupported on aarch64-darwin as of Aug 10 2022 (libhandy)
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    vdirsyncer # sync contacts & calendars
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
  ];

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = "Tomorrow Night Bright",
      }
    '';
  };

  programs.kitty = {
    enable = true;
    theme = "Tomorrow Night Bright";
    font = {
      name = "JetBrains Mono";
      size = 11;
    };
    settings = {
      remember_window_size = false;
    };
  };

  programs.fish = import ./fish/fish.nix pkgs;
  programs.git = import ./git.nix pkgs;
  programs.neovim = import ./neovim.nix pkgs;
  home.file.".sqliterc".source = ./sqliterc;
  xdg.configFile."i3status-rust/config.toml".source =
    ./linux/sway/i3status-rs/config.toml;
  xdg.configFile."khal/config".source = ./khal/config;
  xdg.configFile."nvim/init.lua".source = ./vim/init.lua;
  xdg.configFile."ranger/rc.conf".source = ./ranger/rc.conf;
  xdg.configFile."rg/config".source = ./rg/config;
  xdg.configFile."sway/config".source = ./linux/sway/config;
  xdg.configFile."tig/config".source = ./tig/config;
  xdg.configFile."vdirsyncer/config".source = ./vdirsyncer/config;
  # Hacks / check temporarily if issues get fixed and remove
  # This is here because of https://github.com/FiloSottile/yubikey-agent/issues/92
  home.file.".gnupg/gpg-agent.conf".text = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry";
}
