{
  enable = true;
  aliases = {
    a = "add --all";
    b = "branch";
    ba = "branch -a";
    c = "commit";
    co = "checkout";
    cp = "cherry-pick";
    cam = "commit --amend";
    d = "diff";
    di = "diff --ignore-all-space";
    f = "fetch";
    l = "pull --stat";
    p = "push --recurse-submodules=on-demand";
    r = "rebase";
    rh = "reset --hard";
    ra = "rebase --abort";
    ri = "rebase -i";
    rc = "rebase --continue";
    rs = "rebase --skip";
    rom = "rebase origin/master";
    riom = "rebase -i origin/master";
    s = "!tig status";
    sb = "status -sb";
    sl = "stash list";
    ss = "stash save";
    sp = "stash pop";
    sd = "stash drop";
    su = "submodule update --recursive";
  };
  ignores = [".DS_Store" "*.swp" "tags" ".vscode"];
  extraConfig = {
    commit.verbose = true;
    core = {
      quotepath = false;
      trustctime = false;
      pager = "diffr | less";
    };
    diff = {
      submodule = "log";
      indentHeuristic = true;
      "plist".textconv = "plutil -convert xml1 -o -";
      "png".diff = "exif";
      "gpg".textconv = "gpg --no-tty --decrypt";
    };
    github.user = "supermarin";
    interactive.diffFilter = "diffr";
    merge = {
      tool = "vim";
      log = true;
      stat = true;
    };
    mergetool = {
      keepBackup = false;
      prompt = false;
    };
    pull.rebase = true;
    push.default = "current";
    rebase.autostash = true;
    rerere.enabled = true;
    submodule.fetchJobs = 0;
  };
  userName = "Marin Usalj";
  userEmail = "marin2211@gmail.com";
}


