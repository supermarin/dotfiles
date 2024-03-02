{ config, pkgs, ... }:
{
  systemd.user = {
    # Mail
    # services.mbsync = {
    #   Service = {
    #     Type = "oneshot";
    #     ExecStart = [
    #       "${pkgs.isync}/bin/mbsync -a"
    #       "${pkgs.notmuch}/bin/notmuch new"
    #     ];
    #   };
    #   Unit = {
    #     After = [ "network.target" ];
    #   };
    #   Install = {
    #     WantedBy = [ "default.target" ];
    #   };
    # };
    # timers.mbsync = {
    #   Unit = {
    #     PartOf = [ "mbsync.service" ];
    #   };
    #   Install = {
    #     WantedBy = [ "timers.target" ];
    #   };
    #   Timer = {
    #     OnUnitInactiveSec = "5m";
    #     OnBootSec = "10s";
    #   };
    # };

    # Vdirsyncer
    services.vdirsyncer = {
      Service = {
        ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
        RuntimeMaxExec = "3m";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Unit = {
        After = [ "network.target" ];
        StartLimitBurst = 2;
      };
    };
    timers.vdirsyncer = {
      Unit = {
        PartOf = [ "vdirsyncer.service" ];
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnUnitInactiveSec = "15 m";
        OnBootSec = "5m";
        AccuracySec = "5m";
      };
    };

  };
}
