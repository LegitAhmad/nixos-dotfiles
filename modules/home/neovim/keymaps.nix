{
  programs.nvf.settings.vim = {
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
  };
}
