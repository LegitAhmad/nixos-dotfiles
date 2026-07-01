{ config, pkgs, ... }:

{
  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/hypr";
    recursive = true;
  };
  home.packages = with pkgs; [
  ];
}
