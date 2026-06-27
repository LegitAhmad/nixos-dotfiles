{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.theme;
in
{
  options.theme = {
    enableStylix = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Stylix theming.";
    };

    useWallpaperColors = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Generate the base16 scheme dynamically from the wallpaper. If false, uses the scheme option.";
    };

    scheme = lib.mkOption {
      type = lib.types.str;
      default = "tokyo-night-dark";
      description = "The base16 scheme to use as a fallback when useWallpaperColors is false.";
    };

    polarity = lib.mkOption {
      type = lib.types.enum [
        "dark"
        "light"
        "either"
      ];
      default = "dark";
      description = "The polarity of the theme.";
    };
  };

  config = lib.mkIf cfg.enableStylix {
    environment.systemPackages = with pkgs; [
      gtk3
      gtk4
      qt5.qtbase
      qt6.qtbase
      qt5.qtwayland
      qt6.qtwayland
    ];

    stylix = {
      enable = true;
      image = ../../config/assets/wallpaper.jpg;

      # Conditionally set base16Scheme if not generating from wallpaper
      base16Scheme = lib.mkIf (
        !cfg.useWallpaperColors
      ) "${pkgs.base16-schemes}/share/themes/${cfg.scheme}.yaml";

      polarity = cfg.polarity;

      # Beautiful premium cursor theme
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      # System-wide typography mapping
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sizes = {
          applications = 12;
          terminal = 13;
          desktop = 11;
          popups = 11;
        };
      };

      autoEnable = false;

      # Only enable system-level targets here. Home-manager level targets are managed in home/theme.nix.
      targets = {
        gnome.enable = true;
        gtk.enable = true;
        qt.enable = true;
        chromium.enable = true;
      };
    };
  };
}
