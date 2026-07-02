{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:

let
  enableCatppuccin = if osConfig != null then osConfig.theme.enableCatppuccin else true;
in
lib.mkMerge [

  # --- CATPPUCCIN CONFIGURATION ---
  (lib.mkIf enableCatppuccin {
    catppuccin.enable = true;
    catppuccin.autoEnable = true;
    catppuccin.flavor = "mocha";
    catppuccin.cache.enable = true;
    catppuccin.eza.enable = true;

    home.pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    xdg.configFile."wezterm/colors.lua".text = ''
      return {
        background = "#1e1e2e",
        foreground = "#cdd6f4",
        cursor_bg = "#f5e0dc",
        cursor_fg = "#1e1e2e",
        cursor_border = "#f5e0dc",
        selection_bg = "#45475a",
        selection_fg = "#cdd6f4",
        scrollbar_thumb = "#45475a",
        split = "#585b70",
        ansi = {
          "#45475a",
          "#f38ba8",
          "#a6e3a1",
          "#f9e2af",
          "#89b4fa",
          "#cba6f7",
          "#89dceb",
          "#cdd6f4",
        },
        brights = {
          "#585b70",
          "#f38ba8",
          "#a6e3a1",
          "#f9e2af",
          "#89b4fa",
          "#cba6f7",
          "#89dceb",
          "#f5e0dc",
        },
      }
    '';

    xdg.configFile."niri/colors.kdl".text = ''
      layout {
          focus-ring {
              active-gradient from="#89b4fa" to="#cba6f7" angle=45
              inactive-color "#313244"
          }
      }
    '';

    xdg.configFile."oh-my-posh/config.toml".text = ''
      ${builtins.readFile ../../config/oh-my-posh/config.toml}

      [palette]
      fg = "#cdd6f4"
      blue = "#89b4fa"
      green = "#a6e3a1"
      yellow = "#f9e2af"
      orange = "#fab387"
      purple = "#cba6f7"
      red = "#f38ba8"
      comment = "#6c7086"
      cyan = "#89dceb"
    '';

    programs.oh-my-posh = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      configFile = "/home/legitahmad/.config/oh-my-posh/config.toml";
    };
  })

  # --- COMMON SETTINGS ---
  {
    # Force overwrite gtk settings since backupFileExtension conflicts with
    # pre-existing files from previous home-manager generations
    xdg.configFile."gtk-4.0/settings.ini".force = true;

    # Enforce system-wide dark mode
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  }
]
