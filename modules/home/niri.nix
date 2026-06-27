{ config, pkgs, ... }:

{
  # Symlink the niri config file from the dotfiles repository for hot-reload functionality
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/niri/config.kdl";
}
