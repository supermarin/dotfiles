{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
    ./fonts.nix
  ];
  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  environment.systemPackages = [
    pkgs.cosmic-tasks
  ];
}
