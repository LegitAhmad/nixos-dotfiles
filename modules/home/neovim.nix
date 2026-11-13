{ inputs, ... }:

{
  # NVF owns the editor; each module below owns one area of its configuration.
  # LSP and tooling configurations live in languages.nix; Snacks Lua hooks live in snacks.nix.
  imports = [
    inputs.nvf.homeModules.default
    ./neovim/options.nix
    ./neovim/languages.nix
    ./neovim/completion.nix
    ./neovim/ui.nix
    ./neovim/plugins.nix
    ./neovim/snacks.nix
    ./neovim/keymaps.nix
  ];

  programs.nvf.enable = true;
}
