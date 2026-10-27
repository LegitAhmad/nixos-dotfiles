{
  config,
  repoDir,
  ...
}:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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
      # Shell-specific extras beyond the shared aliases
      # (nix/nh, git, eza, trash aliases come from shell-shared.nix)
      gn = "${repoDir}/scripts/system-shutdown.sh";
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-ai" ];
    settings = {
      auto_sync = true;
      search_mode = "fuzzy";
      inline_height = 20;
      ai.enabled = false;
    };
  };

  # Shell integration flags for the shared tools (see shell-shared.nix)
  programs.direnv.enableZshIntegration = true;
  programs.zoxide.enableZshIntegration = true;
  programs.eza.enableZshIntegration = true;
  programs.fzf.enableZshIntegration = true;
}
