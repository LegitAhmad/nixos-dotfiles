{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # Languages (from Neovim setup)
      jnoortheen.nix-ide
      sumneko.lua
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      ms-python.python
      ms-python.vscode-pylance
      golang.go
      rust-lang.rust-analyzer
      bradlc.vscode-tailwindcss
      tamasfe.even-better-toml
      redhat.vscode-yaml
      yzhang.markdown-all-in-one

      # Quality of Life
      eamodio.gitlens
      visualjj.visualjj
      usernamehw.errorlens
      christian-kohler.path-intellisense
      vscodevim.vim
    ];
    # userSettings = {
    #   "workbench.colorTheme" = "Catppuccin Macchiato";
    #   "workbench.iconTheme" = "catppuccin-macchiato";
    # };
  };
}
