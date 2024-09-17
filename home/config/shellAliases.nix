{
  cd = "z";
  bd = "prevd";
  nd = "nextd";
  eza = "eza --git";
  ls = "eza --git";
  la = "eza --git -a";
  ll = "ls --icons --git -l";
  lt = "ls --icons --tree";
  ltg = "lt --git";
  lta = "lt -a";
  ltl = "lt -l";
  lla = "ls --icons --git -al";
  br = "broot";
  grep = "rg";
  cat = "bat --style=plain";
  du = "dust";
  ps = "procs";
  cloc = "tokei";
  top = "btm";
  htop = "btm";
  mkdir = "mkdir -p";
  vi = "nvim";
  vim = "nvim";
  vis = "nvim -c -S";
  nv = "nvim";
  ":e" = "nvim";
  ":q" = "exit";
  ":qa" = "exit";
  ":x" = "exit";
  ":wq" = "exit";
  ":w" = "cowsay 'You are not in neovim anymore.'";
  ":wa" = "cowsay 'You are not in neovim anymore.'";
  neogit = "nvim -c :Neogit";
  ngit = "nvim -c :Neogit";
  diffview = "nvim -c :DiffviewOpen";
  ndiff = "nvim -c :DiffviewOpen";
  nlog = "nvim -c :DiffviewFileHistory";
  ssh-tunnel = "ssh -vN -L 9999:pdb-aex-teststage-shared.postgres.database.azure.com:5432 fpx-primary";
  proxyon = "export HTTPS_PROXY='http://fpx-primary.valtech.com:8080'";
  proxyoff = "unset HTTPS_PROXY";
  nve = "nvim ~/.config/nvim/lua/config/lazy.lua";

  # Git
  gp = "git pull --autostash";
  g = "git";
  gc = "g commit -v";
  gca = "gc -a";
  gco = "g checkout";
  gcb = "gco -b";
  gd = "g diff";
  gdc = "gd --cached";
  gs = "g status";
  gpl = "g pull";
  gps = "g push";
  gfa = "g fetch --prune --all";
}
