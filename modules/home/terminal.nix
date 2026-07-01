{
  config,
  lib,
  pkgs,
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
    settings = {
      theme = lib.mkDefault "noctalia";
      font-size = 13;
      window-padding-x = 6;
      window-padding-y = 6;
      window-padding-balance = true;
      background-opacity = 0.85;
      confirm-close-surface = false;
    };
  };

  home.activation.cleanGhosttyBackup = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "${config.home.homeDirectory}/.config/ghostty/config.backup"
  '';

  programs.wezterm = {
    enable = true;
  };

  # Symlink the wezterm configuration file from the local dotfiles directory
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/wezterm/wezterm.lua";

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:style=bold:size=13, Noto Color Emoji:size=12, Symbols Nerd Font:size=12";
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
