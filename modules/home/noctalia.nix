{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        default = {
          path = "/home/legitahmad/nixos-dotfiles/config/assets/wallpaper.jpg";
        };
      };

      launch_apps_as_systemd_services = true;
    };
  };

}
