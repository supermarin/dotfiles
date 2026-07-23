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
        ];
        home.packages = with pkgs; [
          (import ../../misc/glide.nix { inherit pkgs; })
          # fastmail-desktop # https://github.com/NixOS/nixpkgs/pull/544808
          inputs.firefox-nightly.packages.${pkgs.stdenv.hostPlatform.system}.firefox-nightly-bin
          inputs.monstar.packages.${pkgs.stdenv.hostPlatform.system}.default # TODO: remove if unused. faster ghostty impl for wayland
          foot
          ghostty
          gnome-clocks
          gnome-calendar
          gram # OSS zed
          libheif # todo: what was this for? iphone photos? does it work?
          libreoffice
          obsidian
          quickemu
          spotify
          ungoogled-chromium
          virt-manager
          vlc
          # zed-editor # TODO: remove when i fix gram server
        ];

        # TODO: remove out of here, should live in de-sway. But de-sway isn't called from home manager, need to see how to include the module
        programs.rofi.enable = true;
        programs.rofi.modes = [
          "drun"
          "emoji"
          "combi"
        ];

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
