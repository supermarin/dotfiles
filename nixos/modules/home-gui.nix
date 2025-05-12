{ pkgs, ... }:
{
  # TODO: inject user into _config for no reason and do users.${user}.imports
  home-manager.users.marin.imports =
    let
      cursor-fhs = pkgs.buildFHSEnv {
        name = "cursor";
        targetPkgs = pkgs: with pkgs; [ code-cursor ];
        runScript = "cursor";
      };
    in
    [
      {
        imports = [
          ../../linux/gnome/dconf.nix
        ];
        home.packages = with pkgs; [
          calibre # books
          cursor-fhs
          discord
          kitty
          libreoffice
          neovide # neovim gui I never use
          neovim-gtk # neovim gui I never use 2
          obsidian
          quickemu
          spotify
          ungoogled-chromium
          virt-manager
          vlc # Unsupported on aarch64-darwin as of Aug 10 2022
          vscodium-fhs
          whatsapp-for-linux
          zed-editor
        ];
        programs.librewolf = {
          enable = true;
          settings = {
            "browser.startup.homepage" = "https://lobste.rs";
            "media.peerconnection.enabled" = false;
            "network.cookie.lifetimePolicy" = 0;
            "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
            "privacy.clearOnShutdown.cookies" = false;
            "privacy.clearOnShutdown.downloads" = false;
            "privacy.clearOnShutdown.history" = false;
            "privacy.resistFingerprinting" = false;
            "webgl.disabled" = false;
            # this was because some sites (document which) were not recognizing librewolf
            # it looks like it's ok now
            # "general.useragent.override" =
            #   "Mozilla/5.0 (X11; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0.1";
          };
        };
      }
    ];
}
