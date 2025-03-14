{
  services.syncthing = {
    enable = true;
    user = "marin";
    configDir = "/home/marin/.config/syncthing";
    settings = {
      gui.theme = "black";
      options.globalAnnounceEnabled = false;
      options.localAnnounceEnabled = false;
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
        simba.id = "HGXXVK4-TSKAZWM-XYLAEH5-USXQ3YV-76YM2RW-K4LTUPQ-FDWEN2I-IG2LDAR";
        simba.addresses = [ "quic://simba" ];
        tokio.id = "3R5ICHB-XN4DEI4-7NUMPI2-DCL24JI-3A2XN2Y-6IG6UTX-VXO22EL-66T3ZQM";
        tokio.addresses = [ "quic://tokio" ];
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
            "simba"
            "mufasa"
          ];
        };
        "~/dotfiles" = {
          id = "lpnyj-66gkm";
          devices = [
            "tokio"
            "simba"
            "mufasa"
          ];
        };
        "~/Pictures" = {
          id = "Pictures";
          devices = [
            "tokio"
            "simba"
            "mufasa"
          ];
        };
        "~/Documents" = {
          id = "Documents";
          devices = [
            "tokio"
            "simba"
            "mufasa"
          ];
        };
      };
    };
  };
}
