{ pkgs, config, ... }:
{
  services = {
    # openvscode-server = {
    #   enable = true;
    #   host = "127.0.0.1";
    #   port = 2345;
    #   telemetryLevel = "off";
    #   user = "marin";
    #   # serverDataDir = "/opt/openvscode-server";
    # };
    jupyterlab = {
      enable = true;
      port = 3333;
      subpath = "/jupyter";
      user = "marin";
      ip = "0.0.0.0"; # doesn't get through the firewall so should be ok
      pythonPackages = (
        p: with p; [
          altair
          pandas
        ]
      );
      RLibs = with pkgs.rPackages; [
        trackeR
        DT
        (pkgs.rPackages.buildRPackage {
          name = "fitfiler";
          buildInputs = [
            pkgs.R
            tidyverse
          ];
          propagatedBuildInputs = [ pkgs.rPackages.leaflet ];
          src = pkgs.fetchFromGitHub {
            owner = "grimbough";
            repo = "FITfileR";
            rev = "a71bb9eaf4b74343e3613ff079a1ff9c5e793e75";
            sha256 = "sha256-+Q6K8VKL0syUZLAuTQ7bapK2uuq91joszyH1b0LANq8=";
          };
        })
      ];
    };
    caddy = {
      enable = true;
      #  virtualHosts."${config.networking.hostName}.TODO.ts.net".extraConfig = ''
      #    reverse_proxy /jupyter* http://127.0.0.1:${toString config.services.jupyterlab.port}
      #    rewrite /code* /
      #    reverse_proxy http://127.0.0.1:${toString config.services.openvscode-server.port}
      #  '';
      # virtualHosts.":80".extraConfig = ''
      virtualHosts."http://${config.networking.hostName}".extraConfig = ''
        reverse_proxy /jupyter* http://127.0.0.1:${toString config.services.jupyterlab.port}
        rewrite /code* /
        reverse_proxy http://127.0.0.1:${toString config.services.openvscode-server.port}
      '';
    };
    ollama.enable = true;
  };
}
