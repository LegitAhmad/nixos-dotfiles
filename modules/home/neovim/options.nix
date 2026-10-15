{ lib, ... }:

let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings.vim = {
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
  };
}
