{ config, lib, pkgs, osConfig ? null, ... }:

let
  enableStylix = if osConfig != null then osConfig.theme.enableStylix else false;
  colors = config.lib.stylix.colors;
in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
    '' + lib.optionalString enableStylix ''
      # Custom colored fish completions (pager) using Stylix base16 colors
      set -g fish_pager_color_progress '#${colors.base0B}' --background='#${colors.base01}'
      set -g fish_pager_color_prefix '#${colors.base0A}' --bold --underline
      set -g fish_pager_color_completion '#${colors.base05}'
      set -g fish_pager_color_description '#${colors.base0D}'
      set -g fish_pager_color_selected_background --background='#${colors.base02}'
      set -g fish_pager_color_selected_prefix '#${colors.base09}' --bold --underline
      set -g fish_pager_color_selected_completion '#${colors.base06}' --bold
      set -g fish_pager_color_selected_description '#${colors.base0E}'
      
      # Disable zebra-striping (alternating row backgrounds)
      set -g fish_pager_color_secondary_background
      set -g fish_pager_color_secondary_prefix '#${colors.base0A}'
      set -g fish_pager_color_secondary_completion '#${colors.base05}'
      set -g fish_pager_color_secondary_description '#${colors.base0D}'
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
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--color-scale=all"
    ];
  };

  # Fzf: A fuzzy finder
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Trash CLI for safe deletion
  home.packages = with pkgs; [ trash-cli ];
}
