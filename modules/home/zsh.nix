{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";

    completionInit = ''
      autoload -Uz compinit
      zmodload zsh/stat
      zmodload zsh/datetime

      _comp_path="''${ZDOTDIR:-$HOME}/.zcompdump"

      if [[ -f "$_comp_path" ]] && stat -A _comp_mtime +mtime "$_comp_path" && (( EPOCHSECONDS - _comp_mtime < 72000 )); then
        compinit -C
      else
        compinit
      fi
      unset _comp_path _comp_mtime
    '';

    history = {
      size = 0;
      save = 0;
      path = "/dev/null";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
      }
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
      }
      {
        name = "oh-my-zsh-git";
        src = pkgs.oh-my-zsh;
        file = "share/oh-my-zsh/plugins/git/git.plugin.zsh";
      }
    ];

    initContent = ''
      # -- Profile zsh startup (comment out after measuring)
      # zmodload zsh/zprof

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^A' beginning-of-line
      bindkey '^E' end-of-line

      # -- zprof output (uncomment with the load above)
      # zprof
    '';

    shellAliases = {
      nrs = "nh os switch";
      nrb = "nh os boot";
      nru = "nh os switch --update";
      ncg = "nix-collect-garbage -d";
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline -n 10";
      rm = "trash-put";
      e = "eza";
      ea = "eza -a";
      el = "eza -l";
      ela = "eza -la";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      search_mode = "fuzzy";
      inline_height = 20;
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };
}
