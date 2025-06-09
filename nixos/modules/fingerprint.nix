{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.age-plugin-tpm ];
  security.tpm2.enable = true;
  security.pam.services.login = {
    fprintAuth = true;
  };
  security.pam.services.gtklock = {
    fprintAuth = true;
    text = ''
      auth sufficient pam_fprintd.so
      auth sufficient pam_unix.so try_first_pass likeauth nullok
      auth required pam_deny.so
    '';
  };
  services.fprintd.enable = true;
  users.users.marin.extraGroups = [ "tss" ];
}
