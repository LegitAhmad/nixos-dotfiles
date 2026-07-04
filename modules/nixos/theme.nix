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
    enableCatppuccin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Catppuccin theming.";
    };
  };

  config = lib.mkIf cfg.enableCatppuccin {
    catppuccin.enable = true;
    catppuccin.autoEnable = true;
    catppuccin.flavor = "mocha";
    catppuccin.cache.enable = true;
  };
}
