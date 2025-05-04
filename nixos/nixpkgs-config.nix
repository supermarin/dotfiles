{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.nh = {
    package = inputs.nh.packages.${pkgs.system}.default;
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 30d --keep 7";
    flake = "/home/marin/dotfiles";
  };
  nixpkgs.config.allowUnfree = true;
  nix = {
    buildMachines = (import ./build-machines.nix config.networking.hostName);
    distributedBuilds = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    # gc = {
    #   automatic = true;
    #   dates = "monthly";
    # };
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
