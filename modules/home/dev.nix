{ config, lib, pkgs, inputs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "legitahmad";
        email = "a.s20061111@gmail.com";
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "legitahmad";
        email = "a.s20061111@gmail.com";
      };
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "git-firefly"
      "tokyo-night"
    ];
    userSettings = {
      theme = lib.mkForce "Tokyo Night";
      ui_font_family = lib.mkForce "JetBrainsMono Nerd Font";
      ui_font_weight = lib.mkForce "bold";
      ui_font_size = lib.mkForce 13;
      buffer_font_family = lib.mkForce "JetBrainsMono Nerd Font";
      buffer_font_weight = lib.mkForce "bold";
      buffer_font_size = lib.mkForce 12;
      vim_mode = lib.mkForce true;
      autosave = "on_focus_change";
      tab_size = 2;
      preferred_line_length = 100;
      format_on_save = "on";
      show_whitespaces = "selection";
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
      features = {
        copilot = false;
      };
      project_panel = {
        dock = "left";
        auto_fold_dirs = true;
      };
      terminal = {
        font_family = "JetBrainsMono Nerd Font";
        font_weight = "bold";
        font_size = 13;
        copy_on_select = true;
      };
      lsp = {
        nil = {
          initializationOptions = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
      };
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = lib.mkDefault "tokyonight";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
        indent-guides = {
          render = true;
        };
      };
    };
  };

  home.packages = with pkgs; [
    nil
    nixfmt
    rustc
    cargo
    nodejs
    go
    python3
    gcc
    vscode
  ];
}
