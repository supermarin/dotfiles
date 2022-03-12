{ pkgs, config, ... }:
{ 
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.mu.enable = true;
  programs.notmuch = {
    enable = true;
    # hooks.preNew = "mbsync --all";  # custom script
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
        notmuch.enable = true;
        mu.enable = true;
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
        };
        primary = true;
        realName = "Marin Usalj";
        address = "m@supermar.in";
        userName = "supermarin@imap.cc";
        passwordCommand = "${pkgs.age}/bin/age -i ~/.age/pk.age -d ~/.age/fm.age";
        imap.host = "imap.fastmail.com";
        smtp.host = "smtp.fastmail.com";
        signature = {
          text = ''
          Marin
          '';
          showSignature = "append";
        };
      };
      sailefx = {
        msmtp.enable = true;
        notmuch.enable = true;
        mu.enable = true;
        mbsync = {
          enable = true;
          create = "both";
          expunge = "both";
        };
        realName = "Marin Usalj";
        address = "marin@sailefx.com";
        userName = "marin@sailefx.com";
        passwordCommand = "age -i $HOME/.age/pk.age -d $HOME/.age/sfx.age";
        imap.host = "imap.zoho.com";
        smtp.host = "smtp.zoho.com";
        signature = {
          text = ''
          Marin
          '';
          showSignature = "append";
        };
      };
    };
  };
}
