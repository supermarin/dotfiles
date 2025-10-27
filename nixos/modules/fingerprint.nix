{
  imports = [ ./tpm.nix ];
  services.fprintd.enable = true;
  security.pam.services.login = {
    fprintAuth = true;
  };
  security.pam.services.swaylock = {
    fprintAuth = true;
    text = ''
      auth sufficient pam_fprintd.so
      auth sufficient pam_unix.so try_first_pass likeauth nullok
      auth required pam_deny.so
    '';
  };
}
