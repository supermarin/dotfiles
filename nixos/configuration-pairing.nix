{ pkgs, modulesPath, ... }:
{

  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];
  #Make sure the virtual machine can boot and attach to its disk.
  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  environment.systemPackages = with pkgs; [
    ripgrep
    (neovim.override { vimAlias = true; })
    ruby_3_1
    tmux
    tmate
  ];

  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix pkgs;
    initialHashedPassword = "$6$PgFBt18zSpr/XWDq$jyemWbiOLzK5vQF.7aSYTQeW33SAfL6Ath31FZEDABVfXvo//K3VAcexXKVlmMYFxxzF9MUogUToEn/ABpOQX/";
  };

  services.openssh.enable = true;

  networking = {
    hostName = "pairing-vm";
    firewall.allowedTCPPorts = [ 22 ];
  };

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "23.05";
}

