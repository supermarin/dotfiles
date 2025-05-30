{ config, ... }:
let
  builders = {
    mufasa = {
      hostName = "mufasa";
      # system = "x86_64-linux";
      speedFactor = 10;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  };
  machines = {
    mx-001 = [ builders.mufasa ];
    simba = [ builders.mufasa ];
    tokio = [ builders.mufasa ];
    dx001 = [ builders.mufasa ];
  };
in
{
  config.nix.distributedBuilds = true;
  config.nix.buildMachines = machines.${config.networking.hostName};
}
