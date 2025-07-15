{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    asdcontrol = {
      url = "github:supermarin/asdcontrol";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    fonts = {
      url = "git+ssh://git@github.com/supermarin/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    jupyter = {
      url = "git+ssh://git@github.com/squale-capital/jupyter";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steven-black-hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      tokio = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-x1.nix
          ./nixos/modules/home-manager-config.nix
          ./nixos/modules/home-gui.nix
          ./nixos/modules/de-sway.nix
          ./nixos/modules/fingerprint.nix
          ./nixos/modules/services/syncthing.nix
          ./nixos/nixpkgs-config.nix
          {
            networking.hostName = "tokio";
            system.stateVersion = "22.05";
          }
        ];
      };

      mufasa = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.jupyter.nixosModules.x86_64-linux.jupyterlab
          ./nixos/configuration.nix
          ./nixos/hardware-computer-1.nix
          ./nixos/modules/home-manager-config.nix
          ./nixos/modules/home-gui.nix
          ./nixos/modules/de-sway.nix
          ./nixos/modules/de-kde.nix
          ./nixos/modules/move-me-mufasa-services.nix
          ./nixos/modules/services/syncthing.nix
          ./nixos/nixpkgs-config.nix
          {
            networking.hostName = "mufasa";
            system.stateVersion = "23.11";
          }
        ];
      };
    };
  };
}
