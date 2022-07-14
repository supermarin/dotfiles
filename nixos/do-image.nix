let
  nixpkgs =
    (
      let
        lock = builtins.fromJSON (builtins.readFile ./flake.lock);
      in
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
        sha256 = lock.nodes.nixpkgs.locked.narHash;
      }
    );
  pkgs = import nixpkgs {};
  config = {
    imports = [ 
      "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix" 
      "${nixpkgs}/nixos/modules/virtualisation/digital-ocean-config.nix"
      ./vpn-configuration.nix
      {
        # Use more aggressive compression then the default.
        virtualisation.digitalOceanImage.compressionMethod = "bzip2";
      }
    ];
  };
in
(pkgs.nixos config).digitalOceanImage
