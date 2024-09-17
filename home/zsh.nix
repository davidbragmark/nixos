{pkgs}: {
  enable = true;
  enableCompletion = true;
  syntaxHighlighting.enable = true;
  autosuggestion.enable = true;

  history = {
    size = 100000;
    path = "$HOME/.cache/zsh_history";
    ignoreAllDups = true;
  };
  dotDir = ".config/zsh";
  defaultKeymap = "emacs";
  dirHashes = {
    dots = "$HOME/config";
    atrain = "$HOME/projects/atrain/";
  };
  historySubstringSearch = {
    enable = true;
    searchUpKey = ["^p"];
    searchDownKey = ["^n"];
  };
  initExtra = ''
    export PAT=3ydra477xrreipsof726wjudtgamp32ddqpqbjmyntssnt4wp7fa

    bindkey '^p' history-search-backward
    bindkey '^n' history-search-forward
    bindkey '^[w' kill-region

    # disable sort when completing `git checkout`
    zstyle ':completion:*:git-checkout:*' sort false

    # set descriptions format to enable group support

    # NOTE: don't use escape sequences here, fzf-tab will ignore them
    zstyle ':completion:*:descriptions' format '[%d]'
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
    zstyle ':completion:*' menu no

    # preview directory's content with eza when completing cd
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

    # switch group using `<` and `>`
    zstyle ':fzf-tab:*' switch-group '<' '>'

    # source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # source $HOME/.config/zsh/plugins/zsh-nix-shell/nix-shell.plugin.zsh
    eval "$(zoxide init zsh)" # Must be called at the end
    eval "$(starship init zsh)"
    eval "$(direnv hook zsh)"
    eval "$(atuin init zsh)"
  '';
  shellAliases = import ./config/shellAliases.nix;
  plugins = [
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.8.0";
        sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      };
    }
    {
      name = "vi-mode";
      src = pkgs.zsh-vi-mode;
      file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    }
    {
      name = "you-should-use";
      src = pkgs.zsh-you-should-use;
      file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
    }
    {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab;
      file = "share/fzf-tab/fzf-tab.plugin.zsh";
    }
    {
      name = "fzf-history-search";
      src = pkgs.zsh-fzf-history-search;
      file = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
    }
  ];
}
