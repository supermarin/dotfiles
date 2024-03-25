host:

let
  mufasa = {
    hostName = "mufasa";
    system = "x86_64-linux";
    speedFactor = 10;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  };
  mx-001 = {
    hostName = "mx-001";
    system = "x86_64-linux";
    speedFactor = 6;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  };
in
{
  mufasa = [ ];
  mx-001 = [ mufasa mx-001 ];
  simba = [ mufasa mx-001 ];
  tokio = [ mufasa mx-001 ];
}.${host}
