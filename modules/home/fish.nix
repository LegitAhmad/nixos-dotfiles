{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
    # Shell-specific extras beyond the shared aliases
    # (nix/nh, git, eza, trash aliases come from shell-shared.nix)

    functions = {
      # mc: make directory and cd into it
      mc = {
        description = "Create a directory and cd into it";
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };
    };
  };

  # Shell integration flags for the shared tools (see shell-shared.nix)
  programs.zoxide.enableFishIntegration = true;
  programs.carapace.enableFishIntegration = true;
  programs.eza.enableFishIntegration = true;
  programs.fzf.enableFishIntegration = true;
}
