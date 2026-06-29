{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [
    inputs.mnw.homeManagerModules.default
  ];

  programs.mnw = {
    # We set enable to false so that the home-manager module doesn't automatically
    # add the standard (non-dev) wrapped Neovim to your home.packages, which would
    # conflict with our devMode wrapper.
    enable = false;

    initLua = ''
      require('legitvim')
    '';

    # Using devMode allows you to iterate on your Lua config (located under config/nvim)
    # without rebuilding the Nix generation every time.
    plugins.dev = {
      legitvim = {
        pure = ../../config/nvim;
        impure = "/home/legitahmad/nixos-dotfiles/config/nvim";
      };
    };

    # Basic plugins that are made available to Neovim.
    # Add any vimPlugins you want Nix to manage here.
    plugins.start = with pkgs.vimPlugins; [
      gruvbox-nvim # Colorscheme
      nvim-treesitter.withAllGrammars # Treesitter parser compilation
      telescope-nvim # Fuzzy finder
      nvim-lspconfig # Quickstart configs for Nvim LSP client
      lualine-nvim # Statusline
      gitsigns-nvim # Git integration
      nvim-web-devicons
      snacks-nvim
      nui-nvim
      noice-nvim
    ];

    # Extra utility packages for LSP, formatters, and treesitter compilation
    extraBinPath = with pkgs; [
      nixd # Nix LSP
      nixfmt # Nix Formatter
      ripgrep # Fast grep for telescope
      fd # Find alternative for telescope
      git # Git CLI integration
      gnumake # Make for building native dependencies
      gcc # C compiler for Treesitter parsers
      lazygit # Git terminal UI
      lua-language-server # Lua LSP
    ];
  };

  # Register the devMode version of mnw.
  # This makes 'nvim' resolve the impure configuration path, enabling hot reloading!
  home.packages = [
    config.programs.mnw.finalPackage.devMode
  ];
}
