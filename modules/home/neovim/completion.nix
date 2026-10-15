{ lib, ... }:

let
  inherit (lib.generators) mkLuaInline;
in
{
  programs.nvf.settings.vim = {
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
  };
}
