{ pkgs, config, lib, ... }:
# TODO: see if it makes sense to enable this on macOS later.
lib.mkIf pkgs.stdenv.isLinux {
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.mu.enable = true;
  programs.notmuch = {
    enable = true;
    new.tags = [ "new" ];
  };
  accounts.email = {
    maildirBasePath = ".mail";
    accounts = {
      butters = {
        msmtp.enable = true;
        notmuch.enable = true;
        mu.enable = true;
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
        };
        realName = "SV BUTTERS";
        address = "info@butte.rs";
        aliases = [ "*@butte.rs" ];
        userName = "butters@mailbox.org";
        passwordCommand = "${pkgs.age}/bin/age -i ~/.age/pk.age -d ~/.age/btrs.age";
        imap.host = "imap.mailbox.org";
        smtp.host = "smtp.mailbox.org";
        signature = {
          text = ''
            SV BUTTERS
            https://butte.rs
          '';
          showSignature = "append";
        };
      };
      fastmail = {
        msmtp.enable = true;
        msmtp.extraConfig = {
          # from = "*@mar.in";
          syslog = "on";
        };
        notmuch.enable = true;
        mu.enable = true;
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
        };
        primary = true;
        realName = "Marin Usalj";
        address = "marin@mar.in";
        aliases = [ "*@mar.in" ];
        userName = "supermarin@imap.cc";
        passwordCommand = "${pkgs.age}/bin/age -i ~/.age/pk.age -d ~/.age/fm.age";
        imap.host = "imap.fastmail.com";
        smtp.host = "smtp.fastmail.com";
        signature = {
          text = ''
            Marin
            https://mar.in
          '';
          showSignature = "append";
        };
      };
    };
  };
}
