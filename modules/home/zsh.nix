{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # history = {
    #   size = 10000;
    #   save = 10000;
    #   path = "${config.home.homeDirectory}/.cache/zsh/history";
    # };

    initContent = ''
      # -- Profile zsh startup (comment out after measuring)
      # zmodload zsh/zprof

      setopt AUTO_CD
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END
      # setopt MENU_COMPLETE
      # setopt EXTENDED_GLOB
      setopt NUMERIC_GLOB_SORT

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
