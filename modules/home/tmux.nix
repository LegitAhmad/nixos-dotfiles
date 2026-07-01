{ config, pkgs, ... }:

let
  tmux-nerd-font-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-nerd-font-window-name";
    version = "unstable-2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "tmux-nerd-font-window-name";
      rev = "0af812a228e1b9f538b8d220c6c59d82d7228973";
      sha256 = "1vyrfc44yyzx94jm8ifmyzqhvfmkrkhm02zxidjlx1gpvms9183g";
    };
  };

  tmux-primary-ip = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-primary-ip";
    version = "unstable-2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "dreknix";
      repo = "tmux-primary-ip";
      rev = "d9323ee6517264e2e0ec2b87f4268eaa534206cd";
      sha256 = "1qkb2nak2c87b21lhzc582vmqg9gnkh28igcrljqdq0i55xhl8yi";
    };
  };

in
{
  # Install tmux as a regular package to bypass Home Manager's generated config
  home.packages = with pkgs; [
    tmux
    sesh
  ];

  # Map the out-of-store symlink directly to ~/.config/tmux/tmux.conf
  xdg.configFile."tmux/tmux.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/tmux/tmux.conf";
    force = true;
  };

  # Automatically generate a plugin loader script so tmux.conf can source it purely
  xdg.configFile."tmux/plugins.conf".text = ''
    run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
    run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
    run-shell ${tmux-nerd-font-window-name}/share/tmux-plugins/tmux-nerd-font-window-name/tmux-nerd-font-window-name.tmux
    run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
    run-shell ${tmux-primary-ip}/share/tmux-plugins/tmux-primary-ip/tmux-primary-ip.tmux
  '';
}
