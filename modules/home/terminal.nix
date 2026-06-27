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
  };

  # Symlink the foot configuration file from the local dotfiles directory
  xdg.configFile."foot/foot.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/foot/foot.ini";
    force = true;
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
