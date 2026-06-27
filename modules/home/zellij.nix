{ config, lib, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false; # Disabled: Terminal emulators (Ghostty/WezTerm) will run Zellij directly instead.
  };

  # Symlink the zjstatus plugin to a stable location
  xdg.configFile."zellij/plugins/zjstatus.wasm".source = pkgs.zellijPlugins.zjstatus;


  # Symlink the zellij configuration file and layouts from local dotfiles directory
  xdg.configFile."zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/zellij/config.kdl";
  xdg.configFile."zellij/layouts/default.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/zellij/layouts/default.kdl";
}
