{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.nh = {
    enable = true;
    # TODO: not sure if I should revert back to vanilla here
    clean.enable = true;
    clean.dates = "monthly";
    clean.extraArgs = "--keep-since 30d --keep 7";
    flake = "/home/marin/dotfiles";
  };
  nixpkgs.config.allowUnfree = true;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    # gc = {
    #   automatic = true;
    #   dates = "monthly";
    # };
    # optimise = {
    #   automatic = true;
    #   dates = [ "monthly" ];
    # };
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      trusted-users = [ "marin" ]; # nix-copy-closure. TODO: see if still needed
    };
  };
}
