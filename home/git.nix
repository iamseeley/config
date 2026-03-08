{ pkgs, ... }: {
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  programs.git = {
    enable = true;

    settings = {
      user.name = "Thomas Seeley";
      user.email = "seeleypersonal@gmail.com";

      alias = {
        st = "status";
        s = "status -sb";
        c = "commit";
        ca = "commit --amend";
        cm = "commit -m";
        co = "checkout";
        cob = "checkout -b";
        br = "branch";
        a = "add";
        aa = "add --all";
        ap = "add -p";
        d = "diff";
        ds = "diff --staged";
        lg = "log --graph --oneline --decorate --all";
        last = "log -1 HEAD";
        l = "log --oneline -10";
        p = "push";
        pl = "pull";
        pf = "push --force-with-lease";
        undo = "reset HEAD~1 --soft";
        unstage = "reset HEAD --";
        save = "stash save";
        pop = "stash pop";
        amend = "commit --amend --no-edit";
        aliases = "config --get-regexp alias";
      };

      core.editor = "nvim";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      rerere.enabled = true;
    };
  };
}
