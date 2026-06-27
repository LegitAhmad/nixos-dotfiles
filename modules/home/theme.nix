{
  config,
  lib,
  pkgs,
  osConfig ? null,
  ...
}:

let
  # Terminals use the system-wide Stylix colors directly to match the system theme
  colors = config.lib.stylix.colors;
in
{
  stylix = {
    autoEnable = false;
    targets = {
      gtk.enable = true;
      qt.enable = true;
      btop.enable = true;
      zen-browser.enable = true;
      vesktop.enable = true;
      yazi.enable = true;
      fish.enable = true;
    };
  };

  # Generate colors.ini for Foot (dynamically linked to system theme)
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

  # Generate styles.json for Carapace (dynamically mapped to Stylix base16 colors)
  xdg.configFile."carapace/styles.json".text = builtins.toJSON {
    carapace = {
      Value = colors.withHashtag.base05;
      Description = "italic ${colors.withHashtag.base03}";
      Error = colors.withHashtag.base08;
      Usage = colors.withHashtag.base0E;
      KeywordPositive = colors.withHashtag.base0B;
      KeywordNegative = colors.withHashtag.base08;
      KeywordUnknown = colors.withHashtag.base09;
      FlagNoArg = colors.withHashtag.base0D;
      FlagArg = colors.withHashtag.base0A;
      FlagMultiArg = colors.withHashtag.base0A;
      FlagOptArg = colors.withHashtag.base0A;
      Highlight1 = colors.withHashtag.base0D;
      Highlight2 = colors.withHashtag.base0B;
      Highlight3 = colors.withHashtag.base0A;
      Highlight4 = colors.withHashtag.base0C;
      Highlight5 = colors.withHashtag.base0E;
      Highlight6 = colors.withHashtag.base08;
      Highlight7 = colors.withHashtag.base09;
      Highlight8 = colors.withHashtag.base0D;
      Highlight9 = colors.withHashtag.base0B;
      Highlight10 = colors.withHashtag.base0A;
      Highlight11 = colors.withHashtag.base0C;
      Highlight12 = colors.withHashtag.base0E;
    };
  };

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

  # Generate ~/.config/oh-my-posh/config.toml dynamically:
  # It extends the static config.toml file and appends the dynamic Stylix colors palette.
  xdg.configFile."oh-my-posh/config.toml".text = ''
    version = 4
    extends = "${config.home.homeDirectory}/nixos-dotfiles/config/oh-my-posh/config.toml"

    [palette]
    fg = "#${colors.base05}"
    blue = "#${colors.base0D}"
    green = "#${colors.base0B}"
    yellow = "#${colors.base0A}"
    orange = "#${colors.base09}"
    purple = "#${colors.base0E}"
    red = "#${colors.base08}"
    comment = "#${colors.base03}"
    cyan = "#${colors.base0C}"
  '';

  # Oh My Posh Prompt
  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
    configFile = "/home/legitahmad/.config/oh-my-posh/config.toml";
  };

  # Dircolors themed dynamically via Stylix base16 colors
  programs.dircolors = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # Directories: Bold Blue (base0D)
      DIR = "01;38;2;${colors.base0D-dec-r};${colors.base0D-dec-g};${colors.base0D-dec-b}";
      # Symbolic Links: Bold Cyan (base0C)
      LINK = "01;38;2;${colors.base0C-dec-r};${colors.base0C-dec-g};${colors.base0C-dec-b}";
      # Sockets: Bold Purple (base0E)
      SOCK = "01;38;2;${colors.base0E-dec-r};${colors.base0E-dec-g};${colors.base0E-dec-b}";
      # Pipes (FIFOs): Orange (base09)
      FIFO = "38;2;${colors.base09-dec-r};${colors.base09-dec-g};${colors.base09-dec-b}";
      # Executables: Bold Green (base0B)
      EXEC = "01;38;2;${colors.base0B-dec-r};${colors.base0B-dec-g};${colors.base0B-dec-b}";
      # Block Devices: Bold Yellow (base0A)
      BLK = "01;38;2;${colors.base0A-dec-r};${colors.base0A-dec-g};${colors.base0A-dec-b}";
      # Character Devices: Bold Yellow (base0A)
      CHR = "01;38;2;${colors.base0A-dec-r};${colors.base0A-dec-g};${colors.base0A-dec-b}";
      # Orphaned/Broken Symlinks: Bold Red (base08)
      ORPHAN = "01;38;2;${colors.base08-dec-r};${colors.base08-dec-g};${colors.base08-dec-b}";
      MISSING = "01;38;2;${colors.base08-dec-r};${colors.base08-dec-g};${colors.base08-dec-b}";
    };
  };
}
