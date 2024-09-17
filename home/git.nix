{pkgs}: {
  enable = true;
  userName = "David Bragmark";
  userEmail = "david.bragmark@valtech.com";
  aliases = {
    cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
    prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
    root = "rev-parse --show-toplevel";
    st = "status";
    p = "push";
    l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --decorate --date=short --color --decorate";
  };
  extraConfig = {
    branch.autosetuprebase = "always";
    color.ui = true;
    column.ui = "auto";
    core.commentchar = ";";
    core.pager = "delta";
    delta = {
      # use n and N to move between diff sections
      navigate = true;
      light = false;
      line-numbers = true;
    };
    merge = {
      tool = "nvim";
      # conflictstyle = "zdiff3";
    };
    diff = {
      tool = "difftastic";
      colorMoved = "default";
      algorithm = "histogram";
    };
    difftool = {
      prompt = false;
      # nvim = {
      #   cmd = "nvim -f -c \"DiffviewOpen $LOCAL..$REMOTE\"";
      # };
      difftastic = {
        cmd = ''difft --color always "$LOCAL" "$REMOTE"'';
      };
    };
    pager.difftool = true;
    alias = {
      dft = "difftool";
    };
  };
}
