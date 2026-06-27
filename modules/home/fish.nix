{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
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

      # Safety alias: send to trash instead of permanent delete
      rm = "trash-put";
    };

    functions = {
      # mc: make directory and cd into it
      mc = {
        description = "Create a directory and cd into it";
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };
    };
  };

  # Modern shell utilities that integrate with Fish:

  # Zoxide: A smarter cd command (z)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Carapace: Multi-shell completion
  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };

  # Eza: A modern, colorful replacement for ls
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
  };

  # Fzf: A fuzzy finder
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Trash CLI for safe deletion
  home.packages = with pkgs; [ trash-cli ];
}
