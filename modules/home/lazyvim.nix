{ inputs, pkgs, ... }:

{
  imports = [
    inputs.lazyvim.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    # Enable LazyVim language/tool extras
    extras = {
      lang.nix.enable = true;
      lang.python = {
        enable = true;
        installDependencies = true;
      };
      lang.go = {
        enable = true;
        installDependencies = true;
      };
      lang.typescript = {
        enable = true;
        installDependencies = true;
      };
    };

    # Extra utility packages for LSP, formatters, treesitter compilation, and telescope
    extraPackages = with pkgs; [
      nil # Nix LSP
      nixfmt # Nix Formatter
      ripgrep # Fast grep for telescope
      fd # Find alternative for telescope
      git # Git CLI integration
      gnumake # Make for building native dependencies
      gcc # C compiler for Treesitter parsers
    ];
  };
}
