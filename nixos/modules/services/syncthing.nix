{
  services.syncthing = {
    enable = true;
    user = "marin";
    configDir = "/home/marin/.config/syncthing";
    settings = {
      gui.theme = "black";
      options.globalAnnounceEnabled = false;
      options.localAnnounceEnabled = false;
      options.ignoredFolders = [
        ".direnv"
        "result"
        "yolo"
      ];
      options.relaysEnabled = false;
      options.natEnabled = false;
      options.urAccepted = -1;
      options.urSeen = 3;
      # TODO harden this a bit more. The current setting is
      # <listenAddress>default</listenAddress>,
      # which listens to https+dynamic relays as well as tcp and quic.
      # Setting the following
      # options.listenAddress = [ "tcp://0.0.0.0:22000" "quic://0.0.0.0:22000" ];
      # doesn't update <listenAddress> in config.xml. Figure out why.
      devices = {
        carbon.id = "6MLXSNZ-2DLBIHF-V4KY5AR-MI4AGJ3-QGIG7BW-VR7TQDH-EVOCZIC-FBW3UAY";
        carbon.addresses = [
          "tcp://carbon:22000"
          "quic://carbon:22000"
          "tcp://carbon"
          "quic://carbon"
        ];
        tokio.id = "3R5ICHB-XN4DEI4-7NUMPI2-DCL24JI-3A2XN2Y-6IG6UTX-VXO22EL-66T3ZQM";
        tokio.addresses = [
          "tcp://tokio"
          "quic://tokio"
        ];
        mufasa.id = "PXHEELW-HDYA4HB-HE536W6-KDDHIE4-AHXWEZ3-H4EOYDI-LB72EZZ-5HDZ3QH";
        mufasa.addresses = [
          "quic://mufasa"
          "tcp://mufasa"
        ];
      };
      folders = {
        "~/base" = {
          id = "ctyq6-lwqs6";
          devices = [
            "tokio"
            "carbon"
            "mufasa"
          ];
        };
        "~/code" = {
          id = "code";
          devices = [
            "tokio"
            "carbon"
            "mufasa"
          ];
        };
        "~/dotfiles" = {
          id = "lpnyj-66gkm";
          devices = [
            "tokio"
            "carbon"
            "mufasa"
          ];
        };
        "~/Pictures" = {
          id = "Pictures";
          devices = [
            "tokio"
            "carbon"
            "mufasa"
          ];
        };
        "~/Documents" = {
          id = "Documents";
          devices = [
            "tokio"
            "carbon"
            "mufasa"
          ];
        };
        "~/.p" = {
          id = "p";
          devices = [
            "tokio"
            "carbon"
            "mufasa"
          ];
        };
        "~/.otp" = {
          id = "otp";
          devices = [
            "tokio"
            "carbon"
            "mufasa"
          ];
        };
      };
    };
  };
}
