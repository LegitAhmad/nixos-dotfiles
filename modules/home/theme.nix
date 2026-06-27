{ config, lib, pkgs, osConfig ? null, ... }:

let
  # Check if Stylix is enabled on the system level
  stylixEnabled = if osConfig != null then osConfig.theme.enableStylix else true;

  # Noctalia theme colors
  noctalia = {
    base00 = "0b1610"; # Background
    base01 = "364b3f";
    base02 = "364b3f";
    base03 = "7f9687";
    base04 = "7f9687";
    base05 = "d9e6db"; # Foreground
    base06 = "b4ccbc";
    base07 = "d9e6db";
    base08 = "ffb4ab"; # Red
    base09 = "ff9e64"; # Orange
    base0A = "c9cb77"; # Yellow
    base0B = "cacd59"; # Green
    base0C = "c9cb77"; # Cyan
    base0D = "90d5ae"; # Blue
    base0E = "cacd59"; # Purple
    base0F = "d9e6db";
  };

  # Terminals use Noctalia colors directly to match desktop shell theme
  colors = noctalia;
in {
  stylix = {
    autoEnable = false;
    targets = {
      gtk.enable = true;
      qt.enable = true;
      btop.enable = true;
      zen-browser.enable = true;
      vesktop.enable = true;
      yazi.enable = true;
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

  # Generate Noctalia theme for Rio
  xdg.configFile."rio/themes/noctalia.toml".text = ''
    [colors]
    background = '#${colors.base00}'
    foreground = '#${colors.base05}'
    cursor = '#${colors.base05}'
    vi-cursor = '#${colors.base0E}'
    selection-background = '#${colors.base02}'
    selection-foreground = '#${colors.base05}'

    # Normal colors
    black = '#${colors.base00}'
    red = '#${colors.base08}'
    green = '#${colors.base0B}'
    yellow = '#${colors.base0A}'
    blue = '#${colors.base0D}'
    magenta = '#${colors.base0E}'
    cyan = '#${colors.base0C}'
    white = '#${colors.base05}'

    # Bright colors
    light-black = '#${colors.base03}'
    light-red = '#${colors.base08}'
    light-green = '#${colors.base0B}'
    light-yellow = '#${colors.base0A}'
    light-blue = '#${colors.base0D}'
    light-magenta = '#${colors.base0E}'
    light-cyan = '#${colors.base0C}'
    light-white = '#${colors.base07}'

    # Dim colors
    dim-black = '#${colors.base01}'
    dim-red = '#${colors.base08}'
    dim-green = '#${colors.base0B}'
    dim-yellow = '#${colors.base0A}'
    dim-blue = '#${colors.base0D}'
    dim-magenta = '#${colors.base0E}'
    dim-cyan = '#${colors.base0C}'
    dim-white = '#${colors.base06}'

    # Tabs and split
    tabs = '#${colors.base01}'
    tabs-foreground = '#${colors.base04}'
    tabs-active = '#${colors.base00}'
    tabs-active-foreground = '#${colors.base05}'
    tabs-active-highlight = '#${colors.base0E}'
    bar = '#${colors.base01}'
    split = '#${colors.base02}'
  '';

  # Generate theme.yml for Eza
  xdg.configFile."eza/theme.yml".text = ''
    colourful: true

    filekinds:
      normal: { foreground: "#${colors.base05}" }
      directory: { foreground: "#${colors.base0D}" }
      symlink: { foreground: "#${colors.base0C}" }
      pipe: { foreground: "#${colors.base03}" }
      block_device: { foreground: "#${colors.base0A}" }
      char_device: { foreground: "#${colors.base0A}" }
      socket: { foreground: "#${colors.base03}" }
      special: { foreground: "#${colors.base0E}" }
      executable: { foreground: "#${colors.base0B}" }
      mount_point: { foreground: "#${colors.base0C}" }

    perms:
      user_read: { foreground: "#${colors.base0C}" }
      user_write: { foreground: "#${colors.base0E}" }
      user_execute_file: { foreground: "#${colors.base0B}" }
      user_execute_other: { foreground: "#${colors.base0B}" }
      group_read: { foreground: "#${colors.base0C}" }
      group_write: { foreground: "#${colors.base09}" }
      group_execute: { foreground: "#${colors.base0B}" }
      other_read: { foreground: "#${colors.base0C}" }
      other_write: { foreground: "#${colors.base08}" }
      other_execute: { foreground: "#${colors.base0B}" }
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
