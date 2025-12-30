{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.backupFileExtension = "bak";
  home-manager.extraSpecialArgs = {
    inputs = inputs;
  };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.marin = {
    imports = [ ../../home.nix ];
    home.stateVersion = config.system.stateVersion;
  };
}
