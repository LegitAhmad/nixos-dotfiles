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

    # Plugins loaded immediately at startup (critical path)
    plugins.start = with pkgs.vimPlugins; [
      catppuccin-nvim # Colorscheme (must load before UI renders)
      nvim-treesitter.withAllGrammars # Treesitter (syntax highlighting)
      mini-nvim # Icons + core editing modules
      snacks-nvim # Dashboard, explorer, and UI framework
      lz-n # Lazy loader itself
    ];

    # Plugins lazy-loaded on demand via lz.n + packadd
    plugins.opt = with pkgs.vimPlugins; [
      gruvbox-nvim
      kanagawa-nvim
      dracula-nvim
      nui-nvim
      noice-nvim
      lualine-nvim
      bufferline-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "jjsigns.nvim";
        version = "unstable";
        src = inputs.jjsigns;
        patches = [ ./jjsigns.patch ];
      })
      (pkgs.vimUtils.buildVimPlugin {
        pname = "sudo.nvim";
        version = "unstable";
        src = inputs.sudo-nvim;
        dependencies = [ pkgs.vimPlugins.nui-nvim ];
      })
      nvim-web-devicons
      telescope-nvim
      nvim-lspconfig
      which-key-nvim
      blink-cmp
      grug-far-nvim
      flash-nvim
      trouble-nvim
      todo-comments-nvim
      conform-nvim
      nvim-lint
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
      typescript-language-server # TypeScript LSP
      eslint_d # TypeScript/JavaScript linter
      prettier # TypeScript/JavaScript formatter
      pyright # Python LSP
      ruff # Python formatter and linter
      stylua # Lua formatter
      gopls # Go LSP
      golangci-lint # Go linter
      rust-analyzer # Rust LSP
      rustfmt # Rust formatter
      nushell # Nushell shell and built-in LSP
      tailwindcss-language-server # Tailwind CSS LSP
      vscode-langservers-extracted # JSON, CSS, HTML LSPs
      yaml-language-server # YAML LSP
      taplo # TOML LSP and formatter
      marksman # Markdown LSP
      bash-language-server # Bash LSP
      shfmt # Bash formatter
      shellcheck # Bash linter
    ];
  };

  # Register the devMode version of mnw.
  # This makes 'nvim' resolve the impure configuration path, enabling hot reloading!
  home.packages = [
    # config.programs.mnw.finalPackage.devMode
    (pkgs.runCommand "mnw-wrapped" { } ''
      mkdir -p $out/bin
      ln -s ${config.programs.mnw.finalPackage.devMode}/bin/nvim $out/bin/mnw
    '')
  ];
}
