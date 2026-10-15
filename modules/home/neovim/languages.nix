{ lib, pkgs, ... }:

let
  inherit (lib.generators) mkLuaInline;
in
{
  # Work around the pnpm dependency hash mismatch in nixpkgs' 6.0.2 package.
  nixpkgs.overlays = [
    (_final: prev: {
      typescript-language-server = prev.typescript-language-server.overrideAttrs (oldAttrs: {
        pnpmDeps = oldAttrs.pnpmDeps.overrideAttrs {
          outputHash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
        };
      });
    })
  ];
  programs.nvf.settings.vim = {
    # ----------------------------------------------------------------------
    # Treesitter / LSP / Languages
    # ----------------------------------------------------------------------
    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
    };

    lsp = {
      enable = true;
      # Keep Neovim's built-in `gr*` mappings instead of adding a
      # `<leader>l` prefix that would shadow the lint mapping below.
      mappings = {
        goToDefinition = null;
        goToDeclaration = null;
        goToType = null;
        listImplementations = null;
        listReferences = null;
        nextDiagnostic = null;
        previousDiagnostic = null;
        openDiagnosticFloat = null;
        documentHighlight = null;
        listDocumentSymbols = null;
        addWorkspaceFolder = null;
        removeWorkspaceFolder = null;
        listWorkspaceFolders = null;
        listWorkspaceSymbols = null;
        hover = null;
        signatureHelp = null;
        renameSymbol = null;
        codeAction = null;
        format = null;
        toggleFormatOnSave = null;
      };

      trouble = {
        enable = true;
        mappings = {
          workspaceDiagnostics = null;
          documentDiagnostics = null;
          lspReferences = null;
          quickfix = null;
          locList = null;
          symbols = null;
        };
      };

      presets.tailwindcss-language-server.enable = true;

      # LSP servers we use, with an extra `.jj` root marker.
      servers =
        (lib.genAttrs
          [
            "nixd"
            "lua-language-server"
            "typescript-language-server"
            "pyright"
            "gopls"
            "rust-analyzer"
            "nushell"
            "bash-language-server"
            "vscode-json-language-server"
            "yaml-language-server"
            "taplo"
            "marksman"
            "tailwindcss-language-server"
          ]
          (_: {
            root_markers = [ ".jj" ];
          })
        )
        // {
          lua-language-server = {
            root_markers = [ ".jj" ];
            settings = {
              Lua = {
                diagnostics.globals = [ "vim" ];
                workspace = {
                  library = mkLuaInline ''vim.api.nvim_get_runtime_file("", true)'';
                  checkThirdParty = false;
                };
                telemetry.enable = false;
              };
            };
          };
        };
    };

    languages = {
      enableTreesitter = true;
      nix = {
        enable = true;
        lsp.servers = [ "nixd" ];
      };
      lua.enable = true;
      typescript.enable = true;
      python = {
        enable = true;
        lsp.servers = [ "pyright" ];
      };
      go.enable = true;
      rust.enable = true;
      nu.enable = true;
      bash.enable = true;
      json.enable = true;
      yaml.enable = true;
      toml.enable = true;
      markdown.enable = true;
      # Grammar support only, no dedicated HTML/CSS LSP servers.
      css = {
        enable = true;
        lsp.enable = false;
      };
      html = {
        enable = true;
        lsp.enable = false;
      };
      scss = {
        enable = true;
        lsp.enable = false;
      };
    };

    # ----------------------------------------------------------------------
    # Formatting (conform) & linting (nvim-lint)
    # ----------------------------------------------------------------------
    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft = {
          lua = [ "stylua" ];
          python = [ "ruff_format" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          nix = [ "nixfmt" ];
          go = [
            "gofmt"
            "goimports"
          ];
          rust = [ "rustfmt" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          toml = [ "taplo" ];
          markdown = [ "prettier" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
        };

        format_on_save = mkLuaInline ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b.disable_autoformat then
              return
            end
            return {
              timeout_ms = 500,
              lsp_fallback = true,
            }
          end
        '';
      };
    };

    diagnostics.nvim-lint = {
      enable = true;
      lint_after_save = false;
      linters_by_ft = {
        python = [ "ruff" ];
        javascript = [ "eslint_d" ];
        typescript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        go = [ "golangcilint" ];
        sh = [ "shellcheck" ];
        bash = [ "shellcheck" ];
      };
    };
    extraPackages = with pkgs; [
      nixd
      nixfmt
      ripgrep
      fd
      git
      gnumake
      gcc
      lazygit
      lua-language-server
      typescript-language-server
      eslint_d
      prettier
      pyright
      ruff
      stylua
      gopls
      golangci-lint
      rust-analyzer
      rustfmt
      nushell
      tailwindcss-language-server
      vscode-langservers-extracted
      yaml-language-server
      taplo
      marksman
      bash-language-server
      shfmt
      shellcheck
    ];
  };
}
