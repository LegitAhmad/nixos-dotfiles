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
      
      # If .zcompdump is less than 20 hours old, run compinit -C to skip safety checks (extremely fast)
      if [[ -f "$_comp_path" ]] && stat -A _comp_mtime +mtime "$_comp_path" && (( EPOCHSECONDS - _comp_mtime < 72000 )); then
        compinit -C
      else
        compinit
      fi
      unset _comp_path _comp_mtime
    '';
    
    # Zsh History options
    history = {
      size = 0;
      save = 0;
      path = "/dev/null";
    };

    # Antidote plugin manager for Zsh
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-history-substring-search"
        "hlissner/zsh-autopair"
        "ohmyzsh/ohmyzsh path:plugins/git"
      ];
    };

    # Keybindings and config
    initContent = ''
      # Bind up and down arrow keys for history substring search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      
      # Better line navigation (similar to emacs/fish)
      bindkey '^A' beginning-of-line
      bindkey '^E' end-of-line
    '';

    # Important aliases
    shellAliases = {
      # NixOS & Home Manager helper (nh) shortcuts
      nrs = "nh os switch";
      nrb = "nh os boot";
      nru = "nh os switch --update";
      ncg = "nix-collect-garbage -d";

      # Git shortcuts
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline -n 10";

      # Safety alias
      rm = "trash-put";

      # Eza shortcuts
      e = "eza";
      ea = "eza -a";
      el = "eza -l";
      ela = "eza -la";
    };
  };

  # Fzf integration for Zsh
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Atuin integration for shell history
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      search_mode = "fuzzy";
    };
  };

  # Eza integration (ls alternative)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };
}
