{ lib, ... }:

{
  programs.nvf.settings.vim = {
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
  };
}
