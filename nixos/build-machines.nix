host:

let
  mufasa = {
    hostName = "mufasa";
    system = "x86_64-linux";
    speedFactor = 10;
    supportedFeatures = [
      "nixos-test"
      "benchmark"
      "big-parallel"
      "kvm"
    ];
  };
in
{
  mufasa = [ ];
  mx-001 = [ mufasa ];
  simba = [ mufasa ];
  tokio = [ mufasa ];
}
.${host}
