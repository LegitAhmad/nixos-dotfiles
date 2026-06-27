{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;               # Enable full mouse support
    baseIndex = 1;              # Start window numbers at 1
    keyMode = "vi";             # Vim shortcuts in scroll mode
    shortcut = "Space";         # Sets prefix to Ctrl + Space natively in Home Manager

    extraConfig = 
      #tmux
      ''
        source-file ${config.home.homeDirectory}/.config/tmux/tmux.extra.conf
      '';

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = 
          #tmux
          ''
            set -g @catppuccin_flavor "mocha"
            
            # Rounded pill style configuration
            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"
            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
            
            # Status line modules
            set -g @catppuccin_status_modules_right "directory session"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_right_separator_inverse "no"
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"
            set -g @catppuccin_directory_text "#{b:pane_current_path}"
          '';
      }
      {
        plugin = tmux-sessionx;
        extraConfig = 
          #tmux
          ''
            # Bound to Prefix + o (Ctrl + Space, then o)
            set -g @sessionx-bind 'o'
            set -g @sessionx-window-height '85%'
            set -g @sessionx-window-width '75%'
            set -g @sessionx-zoxide-mode 'on'
            set -g @sessionx-auto-accept 'off'
            set -g @sessionx-filter-current 'false'
          '';
      }
      {
        plugin = yank; # Native clipboard yanking support
      }
    ];
  };

  xdg.configFile."tmux/tmux.extra.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/tmux/tmux.extra.conf";
    force = true;
  };
}
