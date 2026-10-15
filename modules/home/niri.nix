{
  config,
  pkgs,
  repoDir,
  ...
}:

{
  # Niri starts xwayland-satellite on demand; no second XWayland service.
  home.packages = [ pkgs.xwayland-satellite ];

  xdg.configFile."niri/config.kdl" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoDir}/config/niri/config.kdl";
    force = true;
  };
}
