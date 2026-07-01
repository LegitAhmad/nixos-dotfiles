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
      default = false;
      description = "Enable Stylix theming.";
    };

    enableCatppuccin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Catppuccin theming.";
    };

    useWallpaperColors = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Generate the base16 scheme dynamically from the wallpaper. If false, uses the scheme option.";
    };

    scheme = lib.mkOption {
      type = lib.types.str;
      default = "gruvbox-dark-medium"; # Warm Options: "everforest-dark-hard", "kanagawa", "rose-pine-moon", "gruvbox-dark-medium", "catppuccin-mocha"
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

  config = lib.mkMerge [
    (lib.mkIf cfg.enableStylix {
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
        base16Scheme = lib.mkIf (!cfg.useWallpaperColors) (
          if cfg.scheme == "tokyo-night-vibrant" then {
            base00 = "16161e"; # Background
            base01 = "1f2335"; # Lighter Background
            base02 = "2f3549"; # Selection Background
            base03 = "444b6a"; # Comments, Dark Gray
            base04 = "565f89"; # Non-active/dim foreground
            base05 = "c0caf5"; # Foreground
            base06 = "c0caf5";
            base07 = "c0caf5";
            base08 = "f7768e"; # Red
            base09 = "ff9e64"; # Orange
            base0A = "e0af68"; # Yellow
            base0B = "9ece6a"; # Green
            base0C = "7dcfff"; # Cyan
            base0D = "7aa2f7"; # Blue
            base0E = "bb9af7"; # Magenta/Purple
            base0F = "c0caf5"; # Brown/White
          } else "${pkgs.base16-schemes}/share/themes/${cfg.scheme}.yaml"
        );

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
    })

    (lib.mkIf cfg.enableCatppuccin {
      catppuccin.enable = true;
      catppuccin.autoEnable = true;
      catppuccin.flavor = "mocha";
      catppuccin.cache.enable = true;
    })
  ];
}
