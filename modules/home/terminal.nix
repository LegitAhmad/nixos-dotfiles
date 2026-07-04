{
  config,
  lib,
  pkgs,
  repoDir,
  ...
}:

{
  home.packages = with pkgs; [
    fastfetch
    wget
    brightnessctl
    nushell
    bandwhich
    ripgrep
    ani-cli
    lazygit
    lazyjj
    bat
    cmatrix
    ffmpeg
    imagemagick
    cava
    libnotify
    bottom
    tree
    delta
    gh-dash
    mpvpaper
  ];

  programs.btop = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    enableNushellIntegration = false;
  };

  programs.ghostty = {
    enable = true;
    systemd.enable = true;
  };

  # Symlink the ghostty configuration file from the local dotfiles directory.
  # mkForce overrides the source set by programs.ghostty module.
  xdg.configFile."ghostty/config".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/ghostty/config"
  );

  programs.wezterm = {
    enable = true;
  };

  # Symlink the wezterm configuration file from the local dotfiles directory
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/wezterm/wezterm.lua";

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:style=bold:size=13, Twitter Color Emoji:size=12, Symbols Nerd Font:size=12";
        pad = "6x6";
        dpi-aware = "no";
        selection-target = "both";
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          top = 1;
          left = 2;
        };
      };
      display = {
        separator = "   ";
        color = {
          keys = "cyan";
          title = "bold_cyan";
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "uptime"
        "shell"
        "resolution"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "battery"
        "localip"
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };

}
