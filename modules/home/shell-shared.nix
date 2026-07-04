{
  config,
  lib,
  pkgs,
  ...
}:

# Settings shared across all user shells (aliases + common CLI tools).
# Shell-specific integration flags are set in fish.nix / zsh.nix / nushell.nix.
let
  aliases = {
    # NixOS & Home Manager helper (nh) shortcuts
    # Pass the flake path explicitly so a stale `NH_FLAKE` environment
    # variable cannot make `nh` build an outdated snapshot.
    nrs = "nh os switch .";
    nrb = "nh os boot .";
    nru = "nh os switch --update .";
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

    # Eza shortcuts
    e = "eza";
    ea = "eza -a";
    el = "eza -l";
    ela = "eza -la";
  };
in
{
  programs.fzf = {
    enable = true;
    historyWidget.command = "";
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--color-scale=all"
    ];
  };

  programs.zoxide.enable = true;

  programs.carapace.enable = true;

  programs.fish.shellAliases = aliases;
  programs.zsh.shellAliases = aliases;

  # Trash CLI for safe deletion
  home.packages = with pkgs; [ trash-cli ];
}
