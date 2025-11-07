{ pkgs, ... }:
{
  xdg.configFile."git/attributes".source = ./gitattributes;
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    ignores = [
      ".DS_Store"
      "*.swp"
      "tags"
      ".vscode"
      "result"
      ".direnv"
      "*.qcow2"
      "__pycache__"
    ];
    settings = {
      alias = {
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
      commit.verbose = true;
      core = {
        quotepath = false;
        trustctime = false;
        pager = "diffr | less -R";
      };
      diff = {
        submodule = "log";
        indentHeuristic = true;
        "agediff".textconv = "age-textconv";
        "plist".textconv = "plutil -convert xml1 -o -";
        "png".diff = "exif";
      };
      github.user = "supermarin";
      init.defaultBranch = "main";
      interactive.diffFilter = "diffr";
      merge = {
        tool = "vim";
        log = true;
        stat = true;
        conflictStyle = "zdiff3";
        mergiraf = {
          name = "mergiraf";
          driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
        };
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
      user.name = "Marin";
      user.email = "git@mar.in";
    };
  };
}
