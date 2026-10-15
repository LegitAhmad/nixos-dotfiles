{ inputs, ... }:

{
  # NVF owns the editor; each module below owns one area of its configuration.
  # Tooling overrides live in languages.nix; Snacks Lua hooks live in snacks.nix.
  imports = [
    inputs.nvf.homeManagerModules.default
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
