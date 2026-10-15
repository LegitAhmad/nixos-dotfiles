{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.generators) mkLuaInline;
  # sudo.nvim is not packaged in nvf/nixpkgs, build it from the flake input.
  sudo-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "sudo.nvim";
    version = "unstable";
    src = inputs.sudo-nvim;
    dependencies = [ pkgs.vimPlugins.nui-nvim ];
  };
in
{
  programs.nvf.settings.vim = {
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
    startPlugins = [ pkgs.vimPlugins.vim-tmux-navigator ];

    extraPlugins.sudo-nvim = {
      package = sudo-nvim;
      setup = "require('sudo').setup({})";
    };
  };
}
