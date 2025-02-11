{
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.inter = import ./inter-head.nix { inherit pkgs; };
        packages.sfmono = import ./sfmono.nix { inherit pkgs; };
        packages.sfpro = import ./sfpro.nix { inherit pkgs; };
        packages.newyork = import ./newyork.nix { inherit pkgs; };
      }
    );
}
