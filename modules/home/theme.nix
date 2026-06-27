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

  # Generate colors.ini for Foot (using Tokyo Night Vibrant theme)
  xdg.configFile."foot/colors.ini".text = ''
    [colors-dark]
    alpha=0.85
    background=16161e
    foreground=c0caf5

    # Normal/regular colors
    regular0=15161e
    regular1=f7768e
    regular2=9ece6a
    regular3=e0af68
    regular4=7aa2f7
    regular5=bb9af7
    regular6=7dcfff
    regular7=a9b1d6

    # Bright colors
    bright0=414868
    bright1=f7768e
    bright2=9ece6a
    bright3=e0af68
    bright4=7aa2f7
    bright5=bb9af7
    bright6=7dcfff
    bright7=c0caf5
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
