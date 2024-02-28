{ inputs, pkgs, config, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix = {
    buildMachines = builtins.filter
      (machine: machine.hostName != config.networking.hostName)
      (import ./build-machines.nix);
    distributedBuilds = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    gc = {
      automatic = true;
      dates = "monthly";
    };
    optimise = {
      automatic = true;
      dates = [ "monthly" ];
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      trusted-users = [ "marin" ]; # enable nix-copy-closure
    };
  };
}
