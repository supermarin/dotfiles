{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.nh = {
    enable = true;
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
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      trusted-users = [ "marin" ]; # enable nix-copy-closure
    };
  };
}
