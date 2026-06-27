{ config, lib, pkgs, osConfig ? null, ... }:

let
  # Check if Stylix is enabled on the system level
  stylixEnabled = if osConfig != null then osConfig.theme.enableStylix else true;

  # Tokyo Night fallback colors (used if Stylix is disabled or as default)
  tokyoNight = {
    base00 = "1a1b26"; # Background
    base01 = "16161e";
    base02 = "2f3549";
    base03 = "444b6a";
    base04 = "787c99";
    base05 = "a9b1d6"; # Foreground
    base06 = "cbccd1";
    base07 = "d5d6db";
    base08 = "f7768e"; # Red
    base09 = "ff9e64"; # Orange
    base0A = "e0af68"; # Yellow
    base0B = "9ece6a"; # Green
    base0C = "7dcfff"; # Cyan
    base0D = "7aa2f7"; # Blue
    base0E = "bb9af7"; # Purple
    base0F = "c0caf5";
  };

  # Terminals and other non-gtk/qt tools use Tokyo Night colors directly instead of the custom palette
  colors = tokyoNight;
in {
  stylix = {
    autoEnable = false;
    targets = {
      gtk.enable = true;
      qt.enable = true;
    };
  };

  # Generate colors.ini for Foot
  xdg.configFile."foot/colors.ini".text = ''
    [colors-dark]
    alpha=0.85
    background=${colors.base00}
    foreground=${colors.base05}

    # Normal/regular colors
    regular0=${colors.base00}
    regular1=${colors.base08}
    regular2=${colors.base0B}
    regular3=${colors.base0A}
    regular4=${colors.base0D}
    regular5=${colors.base0E}
    regular6=${colors.base0C}
    regular7=${colors.base05}

    # Bright colors
    bright0=${colors.base03}
    bright1=${colors.base08}
    bright2=${colors.base0B}
    bright3=${colors.base0A}
    bright4=${colors.base0D}
    bright5=${colors.base0E}
    bright6=${colors.base0C}
    bright7=${colors.base07}
  '';

  # Generate colors.lua for WezTerm
  xdg.configFile."wezterm/colors.lua".text = ''
    return {
      background = "#${colors.base00}",
      foreground = "#${colors.base05}",
      cursor_bg = "#${colors.base05}",
      cursor_fg = "#${colors.base00}",
      cursor_border = "#${colors.base05}",
      selection_bg = "#${colors.base02}",
      selection_fg = "#${colors.base05}",
      scrollbar_thumb = "#${colors.base02}",
      split = "#${colors.base03}",
      ansi = {
        "#${colors.base00}",
        "#${colors.base08}",
        "#${colors.base0B}",
        "#${colors.base0A}",
        "#${colors.base0D}",
        "#${colors.base0E}",
        "#${colors.base0C}",
        "#${colors.base05}",
      },
      brights = {
        "#${colors.base03}",
        "#${colors.base08}",
        "#${colors.base0B}",
        "#${colors.base0A}",
        "#${colors.base0D}",
        "#${colors.base0E}",
        "#${colors.base0C}",
        "#${colors.base07}",
      },
    }
  '';

  # Generate colors.kdl for Niri
  xdg.configFile."niri/colors.kdl".text = ''
    layout {
        focus-ring {
            active-gradient from="#${colors.base0D}" to="#${colors.base0E}" angle=45
            inactive-color "#${colors.base02}"
        }
    }
  '';

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
