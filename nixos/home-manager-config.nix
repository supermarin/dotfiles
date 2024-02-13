{ inputs, config, ... }:
{
  home-manager.extraSpecialArgs = { inputs = inputs; };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.marin = {
    home.stateVersion = config.system.stateVersion;
  };
}
