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
      devices = {
        simba.id = "HGXXVK4-TSKAZWM-XYLAEH5-USXQ3YV-76YM2RW-K4LTUPQ-FDWEN2I-IG2LDAR";
        simba.addresses = [ "quic://simba" ];
        tokio.id = "3R5ICHB-XN4DEI4-7NUMPI2-DCL24JI-3A2XN2Y-6IG6UTX-VXO22EL-66T3ZQM";
        tokio.addresses = [ "quic://tokio" ];
        mx-001.id = "4FNONH3-QTHSBAF-NKPXL4A-IDTEYGI-LKC2QN2-RXQ3UUT-CUQFWM6-JFCB7AU";
        mx-001.addresses = [ "quic://mx-001" ];
        mufasa.id = "PXHEELW-HDYA4HB-HE536W6-KDDHIE4-AHXWEZ3-H4EOYDI-LB72EZZ-5HDZ3QH";
        mufasa.addresses = [ "quic://mufasa" ];
      };
      folders = {
        "~/base" = {
          id = "ctyq6-lwqs6";
          devices = [ "tokio" "simba" "mx-001" "mufasa" ];
        };
      };
    };
  };
}


