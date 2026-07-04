{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib.generators) mkLuaInline;
  inherit (inputs.nvf.lib.nvim.dag) entryAnywhere entryAfter;

  # sudo.nvim is not packaged in nvf/nixpkgs, build it from the flake input.
  sudo-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "sudo.nvim";
    version = "unstable";
    src = inputs.sudo-nvim;
    dependencies = [ pkgs.vimPlugins.nui-nvim ];
  };
in
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;

      # ----------------------------------------------------------------------
      # Options
      # ----------------------------------------------------------------------
      lineNumberMode = "relNumber";
      options = {
        shiftwidth = 2;
        tabstop = 2;
        smartindent = true;
        wrap = false;
        hlsearch = false;
        incsearch = true;
        termguicolors = true;
        scrolloff = 8;
        undofile = true;
      };

      # Built-in plugins we do not use.
      globals = {
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
        loaded_gzip = 1;
        loaded_zip = 1;
        loaded_zipPlugin = 1;
        loaded_tar = 1;
        loaded_tarPlugin = 1;
        loaded_tutor_mode_plugin = 1;
        loaded_2html_plugin = 1;
      };

      # ----------------------------------------------------------------------
      # Theme
      # ----------------------------------------------------------------------
      theme = {
        enable = true;
        name = "catppuccin";
        style = "macchiato";
        transparent = true;
      };

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

      # ----------------------------------------------------------------------
      # Completion
      # ----------------------------------------------------------------------
      autocomplete.blink-cmp = {
        enable = true;

        # We define the keymap ourselves, so drop the module defaults.
        mappings = {
          complete = null;
          confirm = null;
          next = null;
          previous = null;
          close = null;
          scrollDocsUp = null;
          scrollDocsDown = null;
        };

        setupOpts = {
          appearance.nerd_font_variant = "mono";

          keymap = {
            preset = "default";
            "<Tab>" = [
              "accept"
              "fallback"
            ];
            "<CR>" = [ "fallback" ];
            "<C-n>" = [
              "select_next"
              "fallback"
            ];
            "<C-p>" = [
              "select_prev"
              "fallback"
            ];
          };

          signature.enabled = true;

          enabled = mkLuaInline ''
            function()
              if vim.bo.buftype == "terminal" or vim.bo.buftype == "nofile" then
                return false
              end
              if vim.fn.getcmdwintype() ~= "" then
                return false
              end
              return true
            end
          '';
        };
      };

      # ----------------------------------------------------------------------
      # UI
      # ----------------------------------------------------------------------
      statusline.lualine = {
        enable = true;
        setupOpts.sections.lualine_x = lib.mkForce [
          "encoding"
          "fileformat"
          "filetype"
          "diff"
        ];
      };

      tabline.nvimBufferline = {
        enable = true;
        mappings = {
          cycleNext = "<S-l>";
          cyclePrevious = "<S-h>";
          closeCurrent = "<leader>bd";
          pick = "<leader>bg";
          sortByExtension = null;
          sortByDirectory = null;
          sortById = null;
          moveNext = null;
          movePrevious = null;
        };
        setupOpts.options = {
          mode = "buffers";
          separator_style = "thin";
          always_show_bufferline = true;
          show_buffer_close_icons = false;
          show_close_icon = false;
        };
      };

      visuals.nvim-web-devicons.enable = true;

      binds.whichKey = {
        enable = true;
        setupOpts = {
          preset = "helix";
          delay = 500;
        };
      };

      ui.noice = {
        enable = true;
        setupOpts = {
          cmdline = {
            enabled = true;
            view = "cmdline_popup";
          };
          messages.enabled = true;
          popupmenu.enabled = true;
          notify.enabled = true;
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = false;
            lsp_doc_border = true;
          };
        };
      };

      # ----------------------------------------------------------------------
      # Git / Notes / Editing utilities
      # ----------------------------------------------------------------------
      git = {
        enable = true;
        gitsigns.enable = true;
      };

      notes.todo-comments = {
        enable = true;
        mappings = {
          quickFix = null;
          telescope = null;
          trouble = null;
        };
      };

      utility = {
        grug-far-nvim.enable = true;

        motion.flash-nvim = {
          enable = true;
          setupOpts.modes.char = {
            enabled = true;
            jump_labels = true;
          };
        };
      };

      mini = {
        extra.enable = true;
        ai = {
          enable = true;
          setupOpts.custom_textobjects.g = mkLuaInline ''require("mini.extra").gen_ai_spec.buffer()'';
        };
        surround.enable = true;
        operators.enable = true;
        pairs.enable = true;
        comment.enable = true;
        move.enable = true;
        splitjoin.enable = true;
        files.enable = true;
      };

      # ----------------------------------------------------------------------
      # snacks.nvim (dashboard, picker, explorer, terminals, ...)
      # ----------------------------------------------------------------------
      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          dashboard = {
            enabled = true;
            sections = [
              { section = "header"; }
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
              (mkLuaInline ''
                (function()
                  local ms = nil
                  return function()
                    if not ms and _G.START_TIME then
                      ms = ((vim.uv or vim.loop).hrtime() - _G.START_TIME) / 1e6
                    end
                    local stats = ms and string.format("⚡ Neovim loaded in %.2fms", ms) or ""
                    return {
                      align = "center",
                      text = {
                        { stats, hl = "SnacksDashboardKey" },
                      },
                    }
                  end
                end)()
              '')
            ];
            preset.keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.picker.files()";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "g";
                desc = "Find Text";
                action = ":lua Snacks.picker.grep()";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.picker.recent()";
              }
              {
                icon = " ";
                key = "e";
                desc = "File Explorer";
                action = ":lua Snacks.explorer()";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ];
          };

          bigfile.enabled = true;
          explorer = {
            enabled = true;
            trash = true;
          };
          git.enabled = true;
          gitbrowse.enabled = true;
          image.enabled = true;
          indent.enabled = true;
          input = {
            enabled = true;
            win = {
              relative = "editor";
              position = "float";
              row = null;
              col = null;
              border = "rounded";
            };
          };
          lazygit = {
            enabled = true;
            configure = true;
          };
          notifier = {
            enabled = true;
            timeout = 3000;
          };
          picker = {
            enabled = true;
            ui_select = true;
            sources.explorer.layout.layout.width = 30;
          };
          quickfile.enabled = true;
          scratch.enabled = true;
          scroll.enabled = true;
          scope.enabled = true;
          statuscolumn.enabled = true;
          terminal.enabled = true;
          words.enabled = true;
        };
      };

      # ----------------------------------------------------------------------
      # Plugins nvf does not ship modules for
      # ----------------------------------------------------------------------
      startPlugins = [ pkgs.vimPlugins.vim-tmux-navigator ];

      extraPlugins.sudo-nvim = {
        package = sudo-nvim;
        setup = "require('sudo').setup({})";
      };

      # LSP servers, formatters, linters and CLI helpers made available to Neovim.
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

      # ----------------------------------------------------------------------
      # Autocommands
      # ----------------------------------------------------------------------
      autocmds = [
        {
          event = [
            "BufWritePost"
            "BufReadPost"
            "InsertLeave"
          ];
          callback = mkLuaInline ''function() require("lint").try_lint() end'';
        }
        {
          event = [ "FileType" ];
          pattern = [ "snacks_picker_input" ];
          callback = mkLuaInline ''
            function()
              local ok, blink = pcall(require, "blink.cmp")
              if ok then
                blink.cancel()
                blink.hide()
              end
            end
          '';
        }
      ];

      # ----------------------------------------------------------------------
      # Keymaps
      # ----------------------------------------------------------------------
      keymaps = [
        # Core
        {
          key = "<C-s>";
          mode = [
            "i"
            "x"
            "n"
            "s"
          ];
          action = "<cmd>w<cr><esc>";
          desc = "Save File";
        }
        {
          key = "<leader>-";
          mode = "n";
          action = "<cmd>split<cr>";
          desc = "Horizontal Split";
        }
        {
          key = "<leader>\\";
          mode = "n";
          action = "<cmd>vsplit<cr>";
          desc = "Vertical Split";
        }
        {
          key = "<esc>";
          mode = [
            "i"
            "n"
          ];
          action = "<cmd>noh<cr><esc>";
          desc = "Clear Highlight and Escape";
        }
        {
          key = "<";
          mode = "v";
          action = "<gv";
          desc = "Indent Less";
        }
        {
          key = ">";
          mode = "v";
          action = ">gv";
          desc = "Indent More";
        }
        {
          key = "<leader>y";
          mode = [
            "n"
            "v"
          ];
          action = ''"+y'';
          desc = "Yank to Clipboard";
        }
        {
          key = "<leader>p";
          mode = [
            "n"
            "v"
          ];
          action = ''"+p'';
          desc = "Paste from Clipboard";
        }
        {
          key = "p";
          mode = "x";
          action = ''"_dP'';
          desc = "Paste without overwriting register";
        }
        {
          key = "<leader>d";
          mode = [
            "n"
            "v"
          ];
          action = ''"_d'';
          desc = "Delete without yanking";
        }
        {
          key = "<leader>c";
          mode = [
            "n"
            "v"
          ];
          action = ''"_c'';
          desc = "Change without yanking";
        }
        {
          key = "x";
          mode = [
            "n"
            "v"
          ];
          action = ''"_x'';
          desc = "Delete character without yanking";
        }
        {
          key = "n";
          mode = "n";
          action = "nzzzv";
          desc = "Next Search Result";
        }
        {
          key = "N";
          mode = "n";
          action = "Nzzzv";
          desc = "Prev Search Result";
        }
        {
          key = "<C-d>";
          mode = "n";
          action = "<C-d>zz";
          desc = "Scroll Down";
        }
        {
          key = "<C-u>";
          mode = "n";
          action = "<C-u>zz";
          desc = "Scroll Up";
        }
        {
          key = "<leader>w";
          mode = "n";
          action = "<cmd>w<cr>";
          desc = "Save File";
        }
        {
          key = "<leader>W";
          mode = "n";
          action = "<cmd>SudoWrite<cr>";
          desc = "Save File as Root (Sudo)";
        }
        {
          key = "<leader>q";
          mode = "n";
          action = "<cmd>q<cr>";
          desc = "Quit Window";
        }
        {
          key = "<leader>Q";
          mode = "n";
          action = "<cmd>q!<cr>";
          desc = "Force Quit Window";
        }

        # Formatting
        {
          key = "<leader>f";
          mode = [
            "n"
            "v"
          ];
          lua = true;
          action = ''function() require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 }) end'';
          desc = "Format Document";
        }
        {
          key = "<leader>tf";
          mode = "n";
          lua = true;
          action = ''
            function()
              vim.g.disable_autoformat = not vim.g.disable_autoformat
              if vim.g.disable_autoformat then
                vim.notify("Autoformat disabled globally", vim.log.levels.WARN, { title = "Conform" })
              else
                vim.notify("Autoformat enabled globally", vim.log.levels.INFO, { title = "Conform" })
              end
            end
          '';
          desc = "Toggle Auto Format globally";
        }
        {
          key = "<leader>tF";
          mode = "n";
          lua = true;
          action = ''
            function()
              vim.b.disable_autoformat = not vim.b.disable_autoformat
              if vim.b.disable_autoformat then
                vim.notify("Autoformat disabled for buffer", vim.log.levels.WARN, { title = "Conform" })
              else
                vim.notify("Autoformat enabled for buffer", vim.log.levels.INFO, { title = "Conform" })
              end
            end
          '';
          desc = "Toggle Auto Format for current buffer";
        }

        # Linting
        {
          key = "<leader>l";
          mode = "n";
          lua = true;
          action = ''function() require("lint").try_lint() end'';
          desc = "Trigger linting for current file";
        }

        # Search & replace
        {
          key = "<leader>sr";
          mode = "n";
          action = "<cmd>GrugFar<CR>";
          desc = "Search & Replace (GrugFar)";
        }

        # Todo comments
        {
          key = "]t";
          mode = "n";
          lua = true;
          action = ''function() require("todo-comments").jump_next() end'';
          desc = "Next Todo Comment";
        }
        {
          key = "[t";
          mode = "n";
          lua = true;
          action = ''function() require("todo-comments").jump_prev() end'';
          desc = "Previous Todo Comment";
        }

        # Trouble
        {
          key = "<leader>xx";
          mode = "n";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          desc = "Diagnostics (Trouble)";
        }
        {
          key = "<leader>xX";
          mode = "n";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
          desc = "Buffer Diagnostics (Trouble)";
        }
        {
          key = "<leader>xs";
          mode = "n";
          action = "<cmd>Trouble symbols toggle focus=false<cr>";
          desc = "Symbols (Trouble)";
        }
        {
          key = "<leader>xl";
          mode = "n";
          action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
          desc = "LSP Definitions/References (Trouble)";
        }
        {
          key = "<leader>xL";
          mode = "n";
          action = "<cmd>Trouble loclist toggle<cr>";
          desc = "Location List (Trouble)";
        }
        {
          key = "<leader>xQ";
          mode = "n";
          action = "<cmd>Trouble qflist toggle<cr>";
          desc = "Quickfix List (Trouble)";
        }
        {
          key = "<leader>xt";
          mode = "n";
          action = "<cmd>Trouble todo toggle<cr>";
          desc = "Todo Comments (Trouble)";
        }

        # Bufferline
        {
          key = "<leader>bp";
          mode = "n";
          action = "<cmd>BufferLinePickClose<CR>";
          desc = "Pick Close Buffer";
        }

        # Snacks
        {
          key = "<leader>gb";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").git.blame_line() end'';
          desc = "Git Blame Line";
        }
        {
          key = "<leader>go";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").gitbrowse() end'';
          desc = "Git Browse Repository";
        }
        {
          key = "<leader>gg";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").lazygit() end'';
          desc = "Toggle Lazygit";
        }
        {
          key = "<leader>e";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").explorer() end'';
          desc = "Toggle File Explorer";
        }
        {
          key = "<leader>sb";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").scratch() end'';
          desc = "Toggle Scratch Buffer";
        }
        {
          key = "<leader>tt";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").terminal() end'';
          desc = "Toggle Terminal";
        }
        {
          key = "<leader><leader>";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").picker.files() end'';
          desc = "Find Files";
        }
        {
          key = "<leader>/";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").picker.grep() end'';
          desc = "Search Grep";
        }
        {
          key = "<leader>fp";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").picker.projects() end'';
          desc = "Search Projects";
        }
        {
          key = "<leader>fr";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").picker.recent() end'';
          desc = "Recent Files";
        }
        {
          key = "<leader>fb";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").picker.buffers() end'';
          desc = "Buffers";
        }
        {
          key = "<leader>su";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").picker.undo() end'';
          desc = "Search Undo History";
        }
        {
          key = "<leader>sp";
          mode = "n";
          lua = true;
          action = ''function() require("snacks").picker() end'';
          desc = "Search Pickers";
        }

        # mini.files
        {
          key = "<leader>mf";
          mode = "n";
          lua = true;
          action = ''
            function()
              local ok, mf = pcall(require, "mini.files")
              if ok and not mf.close() then
                mf.open()
              end
            end
          '';
          desc = "Toggle Mini Files";
        }
      ];

      # ----------------------------------------------------------------------
      # Verbatim Lua (dashboard timing, snacks UI integration and toggles)
      # ----------------------------------------------------------------------
      luaConfigRC = {
        legitvim-start-time = entryAnywhere ''
          _G.START_TIME = (vim.uv or vim.loop).hrtime()
        '';

        legitvim-snacks = entryAfter [ "pluginConfigs" ] ''
          vim.ui.input = require("snacks").input.input
          vim.ui.select = require("snacks").picker.select

          local snacks = require("snacks")
          snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          snacks.toggle.diagnostics():map("<leader>ud")
          snacks.toggle.line_number():map("<leader>ul")
          snacks.toggle.treesitter():map("<leader>uT")
        '';
      };
    };
  };
}
