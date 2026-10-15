{ inputs, lib, ... }:

let
  inherit (lib.generators) mkLuaInline;
  inherit (inputs.nvf.lib.nvim.dag) entryAnywhere entryAfter;
in
{
  programs.nvf.settings.vim = {
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
          # Header artwork from typecraft-dev/dotfiles, nvim/.config/nvim/lua/plugins/snacks.lua.
          # Explicit lines preserve the original spacing without Nix's multiline dedentation.
          preset.header = lib.concatStringsSep "\n" [
            "                                                                     "
            "       ████ ██████           █████      ██                     "
            "      ███████████             █████                             "
            "      █████████ ███████████████████ ███   ███████████   "
            "     █████████  ███    █████████████ █████ ██████████████   "
            "    █████████ ██████████ █████████ █████ █████ ████ █████   "
            "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
            " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
            "        "
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
}
