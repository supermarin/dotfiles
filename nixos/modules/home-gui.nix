{
  inputs,
  ...
}:
{
  # TODO: inject user into _config for no reason and do users.${user}.imports
  home-manager.users.marin.imports = [
    (
      { pkgs, config, ... }:
      let
        dotfiles = "${config.home.homeDirectory}/dotfiles";
        ln = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${file}";
      in
      {
        imports = [
          ../../linux/gnome/dconf.nix
          inputs.zen-browser.homeModules.beta
        ];
        home.packages = with pkgs; [
          (import ../../misc/glide.nix { inherit pkgs; })
          calibre # books
          discord
          ghostty
          gnome-clocks
          libreoffice
          neovide # neovim gui I never use
          neovim-gtk # neovim gui I never use 2
          obsidian
          quickemu
          spotify
          ungoogled-chromium
          virt-manager
          vlc # Unsupported on aarch64-darwin as of Aug 10 2022
          whatsapp-for-linux
          zed-editor
        ];
        programs.zen-browser.enable = true;
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
          };
        };
        xdg.configFile = {
          "cosmic".source = ln "cosmic";
          "ghostty".source = ln "ghostty";
          "kanshi/config".source = ln "kanshi/config";
          "river/init".source = ln "river/init";
          "zed/keymap.json".source = ln "zed/keymap.json";
          "zed/settings.json".source = ln "zed/settings.json";
          "i3status-rust/config.toml".source = ln "linux/i3status-rs/config.toml";
          "sway/config".source = ln "linux/sway/config";
        xdg.desktopEntries = {
          jupyter = {
            name = "Jupyter";
            comment = "Jupyter lab webapp";
            exec = "${pkgs.ungoogled-chromium}/bin/chromium --app=http://mufasa/jupyter";
            mimeType = [ "text/html" ];
            type = "Application";
          };
        };
      }
    )
  ];
}
