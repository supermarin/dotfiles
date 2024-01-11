{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  # TODO: finish this either in HM or in cofiguration.nix.
  #  Sources:
  #    dconf2nix: https://github.com/gvolpe/dconf2nix
  #    nixos module PR (without HM): https://github.com/NixOS/nixpkgs/pull/234615
  #    pop-shell-gnome-45 (script that resets all the keybindings correctly): 
  #    https://github.com/ronanru/pop-shell-gnome-45/blob/master_jammy/scripts/configure.sh
  # dconf.settings = {
  #   # KEYS_GNOME_WM=/org/gnome/desktop/wm/keybindings
  #   # KEYS_GNOME_SHELL=/org/gnome/shell/keybindings
  #   # KEYS_MUTTER=/org/gnome/mutter/keybindings
  #   # KEYS_MEDIA=/org/gnome/settings-daemon/plugins/media-keys
  #   # KEYS_MUTTER_WAYLAND_RESTORE=/org/gnome/mutter/wayland/keybindings/restore-shortcuts
  #   "org/gnome/desktop/wm/keybindings" = {
  #     minimize = [ "<Super>comma" ];
  #     maximize = [ ];
  #   };
  #   "org/gnome/shell/keybindings" = {
  #     open-application-menu = [ ];
  #     toggle-message-tray = [ "<Super>v" ];
  #   };
  #   "org/gnome/mutter/wayland/keybindings/restore-shortcuts" = { };
  # };

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
    oathToolkit # used for OTP
    obsidian
    ripgrep
    rnix-lsp
    rio # terminal, seems to work ok with Berkeley Mono
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

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = "Tomorrow Night Bright",
        font = wezterm.font {
          family = 'SF Mono',
        },
        font_size = 11.0,
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom;
    emacsPackage = pkgs.emacs29-pgtk;
  };

  programs.kitty = {
    enable = true;
    theme = "Tomorrow Night Bright";
    font = {
      name = "SF Mono";
      size = 11;
    };
    settings = {
      remember_window_size = false;
    };
  };

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
