pkgs:

let
  authorizedKeys = pkgs.fetchurl {
    url = "https://github.com/supermarin.keys";
    sha256 = "sha256-Qi1Ikzk2LzhY+laFpM+Bkk0CA+uF/fRDFPp1ZOqZ/CA=";
  };
in
pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys)
