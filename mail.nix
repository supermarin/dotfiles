{ pkgs, config, ... }:

{ 
  programs.astroid = {
    enable = true;
    externalEditor = "alacritty -e nvim -c 'set ft=mail' '+set fileencoding=utf-8' '+set ff=unix' '+set enc=utf-8' %1";
  };
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
        astroid = {
          enable = true;
          extraConfig = {
            save_sent_to = "butters/Sent/cur";
            save_drafts_to = "butters/Drafts/cur";
          };
        };
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
        passwordCommand = "age -i ~/.age/pk.age -d ~/.age/btrs.age";
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
        astroid.enable = true;
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
        passwordCommand = "age -i $HOME/.age/pk.age -d $HOME/.age/fm.age";
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
        astroid.enable = true;
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
