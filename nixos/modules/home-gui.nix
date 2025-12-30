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
          discord
          ghostty
          gnome-clocks
          libreoffice
          neovide # neovim gui I never use
          obsidian
          inputs.quickemu.packages.${pkgs.system}.quickemu # TODO: either start using or ditch
          spotify
          thunderbird
          ungoogled-chromium
          virt-manager
          vlc # Unsupported on aarch64-darwin as of Aug 10 2022
          zed-editor
        ];

        # TODO: remove out of here, should live in de-sway. But de-sway isn't called from home manager, need to see how to include the module
        programs.rofi.enable = true;
        programs.rofi.modes = [
          "drun"
          "emoji"
          "combi"
        ];

        programs.zen-browser.enable = true;
        programs.librewolf = {
          enable = false; # preserving settings, enable if want to reinstall
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
          "i3status-rust/config.toml".source = ln "linux/i3status-rs/config.toml";
          "kanshi/config".source = ln "kanshi/config";
          "river/init".source = ln "river/init";
          "sway/config".source = ln "linux/sway/config";
          "waybar".source = ln "linux/waybar";
          "zed/keymap.json".source = ln "zed/keymap.json";
          "zed/settings.json".source = ln "zed/settings.json";
        };

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
