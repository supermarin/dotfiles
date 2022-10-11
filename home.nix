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
    PASSWORD_STORE_DIR="$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = ./rg/config;
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
    brave
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
    tig
    tree-sitter
    wormhole-william
  ]
  ++ [ # text editing (non-system) fonts
    go-font
    jetbrains-mono
  ]
  ++ lib.optionals isDarwin [] 
  ++ lib.optionals isLinux [
    calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022
    cawbird # twitter
    fractal # matrix. Unsupported on aarch64-darwin as of Aug 10 2022 (libhandy)
    gcc # for neovim
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    tdesktop # telegram
    thunderbird
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.kitty = {
    enable = true;
    theme = "Ir Black";
    font = {
      name = "JetBrains Mono";
      size = 14;
    };
  };

  services.syncthing = {
    enable = isLinux;
  };
  
  home.file.".sqliterc".text = builtins.readFile ./sqliterc;
  home.file.".ssh/config".text = builtins.readFile ./ssh/config;
  programs.fish = import ./fish/fish.nix pkgs;
  programs.git = import ./git.nix;
  xdg.configFile."i3status-rust/config.toml".text = builtins.readFile ./linux/sway/i3status-rs/config.toml;
  xdg.configFile."nvim/colors/supermarin.vim".text = builtins.readFile ./vim/colors/supermarin.vim;
  xdg.configFile."nvim/init.vim".text = builtins.readFile ./vim/init.vim;
  xdg.configFile."nvim/lua/luainit.lua".text = builtins.readFile ./vim/lua/luainit.lua;
  xdg.configFile."rg/config".text = builtins.readFile ./rg/config;
  xdg.configFile."sway/config".text = builtins.readFile ./linux/sway/config;
  xdg.configFile."tig/config".text = builtins.readFile ./tig/config;

  # TEMP: Unfuck ~/Applications on macos. This is less than optimal scenario
  #       because of the noise and because apps are hard copied instead of linked.
  home.activation = mkIf pkgs.stdenv.isDarwin {
    copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        if [ -d "$baseDir" ]; then
          rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        for appFile in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$appFile")"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
        done
    '';
  }; 
}
