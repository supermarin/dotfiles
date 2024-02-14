{ inputs, config, pkgs, ... }:
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
    calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022
    obsidian #TODO: return when https://github.com/NixOS/nixpkgs/issues/273611 is fixed
    age
    age-plugin-yubikey
    autotiling # for sway & i3
    bat # used in `e` for live preview of files
    btop
    cmake # emacs needs to compile vterm
    coreutils # used for `shred`
    diffr # used in git stuff
    direnv
    eza # ls with stuff
    fd
    fractal # matrix. Unsupported on aarch64-darwin as of Aug 10 2022 (libhandy)
    fzf
    inputs.ghostty.packages.${pkgs.system}.ghostty
    git-lfs
    gnumake
    helix
    jq
    khal
    nbstripout
    nodejs-slim_20 # for copilot
    nushell
    oathToolkit # used for OTP
    rio # terminal, seems to work ok with Berkeley Mono
    ripgrep
    rnix-lsp
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    sqlite-interactive
    sumneko-lua-language-server
    tig
    vdirsyncer # sync contacts & calendars
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
    wormhole-william
    zig # why was this? for the compiler IIRC? TODO: delete if unused
    zulip-term
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles = {
      marin = {
        id = 0;
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "https://kagi.com";
          "browser.search.defaultenginename" = "Kagi";
          "browser.search.order.1" = "Kagi";

          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
        };
        search = {
          order = [ "Kagi" "Nixpkgs" "DuckDuckGo" ];
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
          };
        };
        extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          kagi-search
          i-dont-care-about-cookies
          disable-facebook-news-feed
          facebook-container
          # link-cleaner
        ];
      };
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
  xdg.configFile."i3/config".source = ./linux/i3/config;
  xdg.configFile."tig/config".source = ./tig/config;
  xdg.configFile."vdirsyncer/config".source = ./secrets/vdirsyncer.conf;
  # Hacks / check temporarily if issues get fixed and remove
  # This is here because of https://github.com/FiloSottile/yubikey-agent/issues/92
  home.file.".gnupg/gpg-agent.conf".text = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry";
}
