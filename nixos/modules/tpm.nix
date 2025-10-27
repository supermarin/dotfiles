{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.age-plugin-tpm ];
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  users.users.marin.extraGroups = [ "tss" ];
}
