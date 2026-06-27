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
    };
  };

  # Modern shell utilities that integrate with Fish:
  
  # Starship: A customizable, fast, and beautiful shell prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile."starship.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/starship/starship.toml";
    force = true;
  };

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
}
